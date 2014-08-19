require 'spec_helper'

describe Elastic::DSL::Builders::Utils do

  let(:utils) { Class.new { extend Elastic::DSL::Builders::Utils } }

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
        expect(merged = utils.deeper_merge(tree, override, :bool)).to eq(result)
        expect(merged.object_id).not_to eq(result.object_id)
      end
    end

    describe 'deeper_merge!' do
      it 'Merges two querys' do
        expect(utils.deeper_merge!(tree, override, :bool)).to eq(result)
      end
    end
  end

  describe '.find_node' do

    let(:node_value) {'value'}
    let(:wrong_value) {'bad_value'}

    let(:root_node) { {query: {
      test: node_value,
      veronica: nil,
      nested_array: [{jimmy: wrong_value}, {mark: node_value}],
      bad_array: [{jimmy: wrong_value}, wrong_value, {mark: node_value}],
      nested_hash: {ashleigh: true},
    }} }

    it 'raises ArgumentError with blank node_list' do
      expect{utils.find_node([], root_node)}.to raise_error(Elastic::DSL::Errors::InvalidArgument)
    end

    it 'raises InvalidQuery if an array contains a non-hash' do
      expect{utils.find_node([:query, :bad_array, :wrong_value], root_node)}.to raise_error(Elastic::DSL::Errors::InvalidQuery)
    end

    context 'raises NodeNotFound Errors' do

      it 'when a node doesn\'t exist in a hash' do
        expect{utils.find_node([:query, :nested_hash, :not_a_node], root_node)}.to raise_error(Elastic::DSL::Errors::NodeNotFound)
      end

      it 'when a node doesn\'t exist in an array' do
        expect{utils.find_node([:query, :nested_array, :not_a_node], root_node)}.to raise_error(Elastic::DSL::Errors::NodeNotFound)
      end

      it 'when the path ends prematurely' do
        expect{utils.find_node([:query, :not_a_node, :jimmy], root_node)}.to raise_error(Elastic::DSL::Errors::NodeNotFound)
      end

    end

    context 'returns the node\'s value' do

      it 'when queried with an array of keys' do
        expect(utils.find_node([:query], root_node)).to eq(root_node[:query])
      end

      it 'when queried with a single key' do
        expect(utils.find_node(:query, root_node)).to eq(root_node[:query])
      end

      it 'when it maps to nil' do
        expect(utils.find_node([:query, :veronica], root_node)).to eq(nil)
      end

      it 'from a nested hash' do
        expect(utils.find_node([:query, :test], root_node)).to eq(node_value)
      end

      it 'from a nested array' do
        expect(utils.find_node([:query, :nested_array], root_node)).to eq(root_node[:query][:nested_array])
      end

      it 'from a nested hash in an array' do
        expect(utils.find_node([:query, :nested_array, :mark], root_node)).to eq(node_value)
      end

    end

  end

  # describe '.foc_node!' do

  #   let(:node_value) {'value'}
  #   let(:wrong_value) {'bad_value'}

  #   let(:root_node) { {query: {
  #     nested_array: [{jimmy: wrong_value}, {mark: node_value}],
  #     nested_hash: {ashleigh: true},
  #   }} }

  #   let(:foc_hash) { {query: {
  #     nested_hash: {ashleigh: true, not_a_node: nil},
  #   }} }


  #   context 'creates the node' do

  #     it 'when a node doesn\'t exist in a hash' do
  #       expect(utils.foc_node!([:query, :nested_hash, :not_a_node], root_node)).to eq(foc_hash[:query][:nested_hash][:not_a_node])
  #     end

  #     it 'when a node doesn\'t exist in an array' do
  #       expect(utils.foc_node!([:query, :nested_array, :not_a_node], root_node)).to raise_error(Elastic::DSL::Errors::NodeNotFound)
  #     end

  #     it 'when the path ends prematurely' do
  #       expect(utils.foc_node!([:query, :not_a_node, :jimmy], root_node)).to raise_error(Elastic::DSL::Errors::NodeNotFound)
  #     end

  #   end

  # end

  describe '.create_nodes!' do
    let(:root_node) { {query: nil} }
    let(:result) { {query: {ashleigh: {frank: {jimmy: {}}}}} }

    it 'creates the nodes' do
      utils.create_nodes!([:query, :ashleigh, :frank, :jimmy], root_node)
      expect(root_node).to eq(result)
    end

    it 'returns the parent of the last key' do
      expect(utils.create_nodes!([:query, :ashleigh, :frank, :jimmy], root_node)).to eq({jimmy: {}})
    end
  end

  describe '.blank?' do
    it 'returns true for single args' do
      expect(utils.blank?(*[])).to eq(true)
      expect(utils.blank?()).to eq(true)
      expect(utils.blank?(nil)).to eq(true)
      expect(utils.blank?(*nil)).to eq(true)
      expect(utils.blank?([])).to eq(true)
      expect(utils.blank?({})).to eq(true)
      expect(utils.blank?('')).to eq(true)
    end
    it 'returns false for single args' do
      expect(utils.blank?(Object)).to eq(false)
      expect(utils.blank?('test')).to eq(false)
      expect(utils.blank?(2)).to eq(false)
    end

    it 'returns true for multiple args' do
      expect(utils.blank?([[]])).to eq(true)
      expect(utils.blank?([], [])).to eq(true)
      expect(utils.blank?({}, [])).to eq(true)
      expect(utils.blank?(nil, [])).to eq(true)
    end

    it 'returns false for multiple args' do
      expect(utils.blank?([], ['s'])).to eq(false)
      expect(utils.blank?(1,2,3)).to eq(false)
      expect(utils.blank?('a', 2, 'b')).to eq(false)
    end
  end
end
