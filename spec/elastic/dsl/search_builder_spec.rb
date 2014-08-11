require 'spec_helper'

describe Elastic::DSL::SearchBuilder do

  let(:builder) { Elastic::DSL::SearchBuilder.new }

  describe '.initialize' do
    it 'succeeds in creating' do
      expect(builder.class).to eq(Elastic::DSL::SearchBuilder)
    end
    # it 'returns true' do
    #   expect(builder.es_query.is_a?(ActiveSupport::HashWithIndifferentAccess)).to eq (true)
    # end
  end

end
