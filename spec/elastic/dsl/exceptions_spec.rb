require 'spec_helper'

describe Elastic::DSL::Errors do
  E = Elastic::DSL::Errors

  context 'Can be initialized' do
    [E::Error, E::InvalidQuery, E::InvalidArgument, E::NodeNotFound].each do |klass|
      it "#{klass} can be initialized" do
        expect(klass.new.class).to eq(klass)
      end
    end
  end

  describe E::NodeNotFound do
    let(:message) { 'test' }
    let(:index) { 4 }
    it 'returns index' do
      expect(E::NodeNotFound.new(index).index).to eq(index)
    end

    it 'returns message' do
      expect(E::NodeNotFound.new(index, message).message).to eq(message)
    end

    it 'returns to_s with message' do
      expect(E::NodeNotFound.new(index, message).to_s).to eq(message)
    end

    it 'returns to_s with default message' do
      expect(E::NodeNotFound.new(index).to_s).to eq('Could not find node at node_keys[4]')
    end
  end

end
