require 'spec_helper'

describe Elastic::DSL::Builders::Queries::Bool do

  let(:builder) { Elastic::DSL::SearchBuilder.new(base) }
  let(:condition) { {match: {term: {test_b: 1}}} }

  describe 'bool queries' do
    [:should, :must, :must_not].each do |key|
      describe ".#{key}" do

        let(:base) { {query: {}} }
        let(:merge_base) { {
          query: {
            bool: {
              key => [
                {match: {term: {test_a: 1}}}
              ]
            }
          }
        }}
        let(:result) { {
          query: {
            bool: {
              key => [
                {match: {term: {test_b: 1}}}
              ]
            }
          }
        }}

        it "constructs the missing bool and #{key} node" do
          expect(builder.send(key, condition).es_query).to eq(result)
        end

        it "constructs the missing #{key} node" do
          builder.es_query[:query][:bool] = {}
          expect(builder.send(key, condition).es_query).to eq(result)
        end

        it "merges with existing #{key} node" do
          result[:query][:bool][key].unshift(
              {match: {term: {test_a: 1}}})
          builder = Elastic::DSL::SearchBuilder.new(merge_base)
          expect(builder.send(key, condition).es_query).to eq(result)
        end
      end
    end
  end

  describe 'nested bool queries' do
    [:should, :must, :must_not].each do |key|
      describe ".#{key}" do

        let(:base) { {
          query: {
            bool: {
              key => [
                {match: {term: {test_a: 1}}}
              ]
            }
          }
        }}
        let(:merge_base) { {
          query: {
            bool: {
              key => [
                {match: {term: {test_a: 1}}},
                {bool: {
                  key => [
                    {match: {term: {test_a: 1}}}
                  ]
                }}
              ]
            }
          }
        }}
        let(:result) { {
          query: {
            bool: {
              key => [
                {match: {term: {test_a: 1}}},
                {bool: {
                  key => [
                    {match: {term: {test_b: 1}}}
                  ]
                }}
              ]
            }
          }
        }}
        let(:merge_result) { {
          query: {
            bool: {
              key => [
                {match: {term: {test_a: 1}}},
                {bool: {
                  key => [
                    {match: {term: {test_a: 1}}},
                    {match: {term: {test_b: 1}}}
                  ]
                }}
              ]
            }
          }
        }}

        it "constructs the missing bool and #{key} node" do
          expect(builder.send(key, condition, base[:query][:bool][key]).es_query).to eq(result)
        end

        it "constructs the missing #{key} node" do
          builder.es_query[:query][:bool][key] << {bool: {}}
          expect(builder.send(key, condition, base[:query][:bool][key]).es_query).to eq(result)
        end

        it "merges with existing #{key} node" do
          builder = Elastic::DSL::SearchBuilder.new(merge_base)
          expect(builder.send(key, condition, merge_base[:query][:bool][key]).es_query).to eq(merge_result)
        end

      end
    end
  end

end
