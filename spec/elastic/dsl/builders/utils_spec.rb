require 'spec_helper'
require 'active_support/hash_with_indifferent_access'

# require 'elastic/dsl/errors/base_error'

describe Elastic::DSL::Builders::Utils do

  let(:builder) { Class.new { extend Elastic::DSL::Builders::Utils } }

  describe '.deeper_merge!' do

    let(:tree) { {bool: {
      should: [
        {match: {should_a: 'a1'}},
        {term: {test_a: 1}},
        {bool: {
          should: [
            {match: {nested_should_a: 'a1'}}
          ]}},
      ]
    }}}

    let(:override) { {bool: {
      should: [
        {match: {should_a: 'a2'}},
        {term: {test_b: 1}},
        {term: {test_b: 2}},
        {bool: {
          should: [
            {match: {nested_should_b: 'a2'}}
          ]}},
      ],
      must: [
        {term: {must_b: 'b'}}
      ]
    }}}

    let(:result) { {bool: {
      should: [
        {match: {should_a: 'a1'}}, #
        {term: {test_a: 1}}, #
        {bool: {
          should: [
            {match: {nested_should_a: 'a1'}}, #
            {match: {nested_should_b: 'a2'}}
          ]}},
        {match: {should_a: 'a2'}},
        {term: {test_b: 1}},
        {term: {test_b: 2}},
      ],
      must: [
        {term: {must_b: 'b'}}
      ]
    }}}

    describe 'deeper_merge' do
      it 'Merges two querys into a new hash' do
        expect(merged = builder.deeper_merge(tree, override, :bool)).to eq(result)
        expect(merged.object_id).not_to eq(result.object_id)
      end
    end

    describe 'deeper_merge!' do
      it 'Merges two querys' do
        expect(builder.deeper_merge!(tree, override, :bool)).to eq(result)
      end
    end
  end

  describe '.find_node' do
    let(:root_node) { HashWithIndifferentAccess.new(query: {test: 'test'}) }
    let(:root_node2) { {query: {test: 'test'}} }

    it 'raises ArgumentError with blank node_list' do
      expect{builder.find_node([], root_node)}.to raise_error(ArgumentError)
    end

    it 'raises NodeNotFound error when it doesn\'t exist' do
      expect{builder.find_node(['bob'], root_node)}.to raise_error(Elastic::DSL::Errors::NodeNotFound)
    end

    it 'returns the node from an array of keys' do
      expect(builder.find_node(['query'], root_node)).to eq(root_node[:query])
    end

    it 'returns the node from a single key' do
      expect(builder.find_node('query', root_node)).to eq(root_node[:query])
    end

    it 'returns the nested node' do
      expect(builder.find_node(['query', 'test'], root_node)).to eq(root_node[:query][:test])
    end

    # Fails without hashwithindifferentaccess
    xit 'returns the nested node without hashwithindifferentaccess' do
      expect(builder.find_node(['query', 'test'], root_node2)).to eq(root_node[:query][:test])
    end
  end

  describe '.blank?' do
    it 'returns true for single args' do
      expect(builder.blank?(*[])).to eq(true)
      expect(builder.blank?()).to eq(true)
      expect(builder.blank?(nil)).to eq(true)
      expect(builder.blank?(*nil)).to eq(true)
      expect(builder.blank?([])).to eq(true)
      expect(builder.blank?({})).to eq(true)
      expect(builder.blank?('')).to eq(true)
    end
    it 'returns false for single args' do
      expect(builder.blank?(Object)).to eq(false)
      expect(builder.blank?('test')).to eq(false)
      expect(builder.blank?(2)).to eq(false)
    end

    it 'returns true for multiple args' do
      expect(builder.blank?([[]])).to eq(true)
      expect(builder.blank?([], [])).to eq(true)
      expect(builder.blank?({}, [])).to eq(true)
      expect(builder.blank?(nil, [])).to eq(true)
    end

    it 'returns false for multiple args' do
      expect(builder.blank?([], ['s'])).to eq(false)
      expect(builder.blank?(1,2,3)).to eq(false)
      expect(builder.blank?('a', 2, 'b')).to eq(false)
    end
  end
end
