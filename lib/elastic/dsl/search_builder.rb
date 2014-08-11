# require 'active_support/hash_with_indifferent_access'
module Elastic
  module DSL
    class SearchBuilder
      include Elastic::DSL::Builders::Queries::All
      include Elastic::DSL::Builders::Filters::All
      include Elastic::DSL::Builders::Interface

      attr_reader :es_query


      def initialize(search_query = {query: {}})
        raise ArgumentException unless search_query

        # Point Cut around all Elastic::DSL Methods
        around(*elastic_dsl_methods, ->(*args){return self if blank?(*args)}, ->{return self} )
        # around(:geo_distance, ->(args){binding.pry}, ->{return self} )

        # @es_query ||= HashWithIndifferentAccess.new(search_query)
        @es_query ||= search_query
      end

      def node(node_keys)
        return find_node(node_keys, es_query)
      end

    end

  end
end
