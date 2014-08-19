require 'spec_helper'

describe Elastic::DSL::Builders::Filters::Range do

  let(:builder) { Elastic::DSL::SearchBuilder.new() }
  let(:min) { 6 }
  let(:max) { 23 }

  let(:range_inc) { {gte: min, lte: max} }
  let(:range_exc) { {gt: min, lt: max} }
  let(:range_mix) { {gte: min, lt: max} }

  describe '.range' do
    [:range_inc, :range_exc, :range_mix].each do |range|

      let(:result) { { query: {},
        filter: {range: {
        age: range
      }}} }

      it "filters #{range}" do
        expect(builder.range('age', range).es_query).to eq(result)
      end
    end

  end

end
