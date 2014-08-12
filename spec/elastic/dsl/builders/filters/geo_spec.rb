require 'spec_helper'

describe Elastic::DSL::Builders::Filters::Geo do

  let(:builder) { Elastic::DSL::SearchBuilder.new() }
  let(:lat) { 49.261173248291016 }
  let(:lon) { -123.1111831665039 }
  let(:distance) { '10km' }

  let(:merge_base) { { query: {}, filter: {existing: :node} } }

  let(:result) { { query: {},
    filter: {geo_distance: {
    distance: distance,
    'location' => {
      lat: lat,
      lon: lon
    }
  }}} }

  describe '.geo_distance' do

    it 'creates a geo_distance filter' do
      expect(builder.geo_distance(lat, lon, '10km').es_query).to eq(result)
    end

    it 'merges with existing filter node' do
      result[:filter][:existing] = :node
      builder = Elastic::DSL::SearchBuilder.new(merge_base)
      expect(builder.geo_distance(lat, lon, '10km').es_query).to eq(result)
    end
  end

end
