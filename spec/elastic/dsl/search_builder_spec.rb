require 'spec_helper'

describe Elastic::DSL::SearchBuilder do

  let(:builder) { Elastic::DSL::SearchBuilder.new }

  describe '.initialize' do
    it 'succeeds in creating' do
      expect(builder.class).to eq(Elastic::DSL::SearchBuilder)
    end
  end

  describe '.node?' do
    it 'raises exception if node cannot be found' do
      expect{builder.node?([:some_node])}.to raise_exception(Elastic::DSL::Errors::NodeNotFound)
    end

    it 'returns the value of the node' do
      builder = Elastic::DSL::SearchBuilder.new(test: 'test')
      expect(builder.node?([:test])).to eq('test')
    end

    it 'returns a nil value for a non-existent node' do
      builder = Elastic::DSL::SearchBuilder.new(test: nil)
      expect(builder.node?([:test])).to eq(nil)
    end
  end

  describe '.size?' do
    it 'returns the size' do
      expect(builder.size?).to eq(nil)
    end
  end

  describe '.size' do

    it 'can be set' do
      builder.size(20)
      expect(builder.size?).to eq(20)
    end

    it 'returns the builder for chaining' do
      expect(builder.size(20)).to eq(builder)
    end

  end

end
