require 'spec_helper'

describe Elastic::DSL::Builders::Core::Bool do

  let(:builder) { Elastic::DSL::SearchBuilder.new(base) }
  let(:condition) { {match: {term: {test_b: 1}}} }

  [:query, :filter].each do |search_type|
    describe "bool #{search_type}" do
      [:should, :must, :must_not].each do |key|
        describe ".#{key}" do

          let(:base) { {search_type => {}} }
          let(:merge_base) { {
            search_type => {
              bool: {
                key => [
                  {match: {term: {test_a: 1}}}
                ]
              }
            }
          }}
          let(:result) { {
            search_type => {
              bool: {
                key => [
                  {match: {term: {test_b: 1}}}
                ]
              }
            }
          }}
          let(:options) { {filter: true} if search_type == :filter }

          it "constructs the missing bool and #{key} node" do
            expect(builder.public_send(key, condition, options).es_query).to eq(result)
          end

          it "constructs the missing #{key} node" do
            builder.es_query[search_type][:bool] = {}
            expect(builder.public_send(key, condition, options).es_query).to eq(result)
          end

          it "merges with existing #{key} node" do
            result[search_type][:bool][key].unshift(
                {match: {term: {test_a: 1}}})
            builder = Elastic::DSL::SearchBuilder.new(merge_base)
            expect(builder.public_send(key, condition, options).es_query).to eq(result)
          end

        end
      end
    end

    describe "nested bool #{search_type}" do
      [:should, :must, :must_not].each do |key|
        describe ".#{key}" do

          let(:base) { {
            search_type => {
              bool: {
                key => [
                  {match: {term: {test_a: 1}}}
                ]
              }
            },
          }}
          let(:merge_base) { {
            search_type => {
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
            },
          }}
          let(:result) { {
            search_type => {
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
            },
          }}
          let(:merge_result) { {
            search_type => {
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
            },
          }}
          let(:options) { {filter: true} if search_type == :filter }

          it "constructs the missing bool and #{key} node" do
            expect(builder.public_send(key, condition, {root: base[search_type][:bool][key]}).es_query).to eq(result)
          end

          it "constructs the missing #{key} node" do
            builder.es_query[search_type][:bool][key] << {bool: {}}
            expect(builder.public_send(key, condition, {root: base[search_type][:bool][key]}).es_query).to eq(result)
          end

          it "merges with existing #{key} node" do
            builder = Elastic::DSL::SearchBuilder.new(merge_base)
            expect(builder.public_send(key, condition, {root: merge_base[search_type][:bool][key]}).es_query).to eq(merge_result)
          end

        end
      end
    end

    describe "multiple nested bool #{search_type}" do
      [:should, :must, :must_not].each do |key|
        describe ".#{key}" do

          let(:base) { {
            search_type => {
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
          let(:result) { {
            search_type => {
              bool: {
                key => [
                  {match: {term: {test_a: 1}}},
                  {bool: {
                    key => [
                      {match: {term: {test_b: 1}}}
                    ]
                  }},
                  {bool: {
                    key => [
                      {match: {term: {test_c: 1}}}
                    ]
                  }},
                ]
              }
            }
          }}
          let(:condition) { {match: {term: {test_c: 1}}} }

          it "appends a bool and #{key} node" do
            expect(builder.public_send(key, condition, {root: base[search_type][:bool][key], append: true}).es_query).to eq(result)
          end

        end
      end
    end

      describe ".one_of_these (#{search_type})" do

        let(:base) { {
          search_type => {
            bool: {
              must: [
                {match: {term: {test_a: 1}}},
                {bool: {
                  should: [
                    {match: {term: {test_b: 1}}}
                  ]
                }}
              ]
            }
          }
        }}
        let(:result) { {
          search_type => {
            bool: {
              must: [
                {match: {term: {test_a: 1}}},
                {bool: {
                  should: [
                    {match: {term: {test_b: 1}}}
                  ]
                }},
                {bool: {
                  should: [
                    {match: {term: {test_c: 1}}}
                  ]
                }},
              ]
            }
          }
        }}
        let(:condition) { {match: {term: {test_c: 1}}} }
        let(:options) { {filter: true} if search_type == :filter }


        it "nests a group of should conditions under the top level must" do
          expect(builder.public_send(:one_of_these, condition, options).es_query).to eq(result)
        end

      end

  end
end
