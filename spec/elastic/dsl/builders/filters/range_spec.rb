require 'spec_helper'

describe Elastic::DSL::Builders::Filters::Range do

  let(:builder) { Elastic::DSL::SearchBuilder.new() }
  let(:min) { 6 }
  let(:max) { 23 }

  let(:ranges) { {inc: {gte: min, lte: max}, exc: {gt: min, lt: max}, mix: {gte: min, lt: max}} }

  describe '.range' do
    [:inc, :exc, :mix].each do |range|

      let(:result) { { query: {},
        filter: {range: {
        age: ranges[range]
      }}} }

      it "filters #{range}" do
        expect(builder.range('age', ranges[range]).es_query).to eq(result)
      end
    end

  end

end
