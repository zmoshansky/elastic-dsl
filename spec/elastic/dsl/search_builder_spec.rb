require 'spec_helper'

describe Elastic::DSL::SearchBuilder do

  let(:builder) { Elastic::DSL::SearchBuilder.new }

  describe '.initialize' do
    it 'succeeds in creating' do
      expect(builder.class).to eq(Elastic::DSL::SearchBuilder)
    end
  end

end
