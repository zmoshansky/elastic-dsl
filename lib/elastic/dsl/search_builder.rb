module Elastic
  module DSL
    class SearchBuilder
      include Elastic::DSL::Builders::Queries::All
      include Elastic::DSL::Builders::Filters::All
      include Elastic::DSL::Builders::Interface

      attr_accessor :es_query


      def initialize(search_query = {query: {}, filter: {}})
        raise ArgumentException unless search_query

        # Point Cut around all Elastic::DSL Methods
        around(*elastic_dsl_methods, ->(*args){return self if blank?(*args)}, ->{return self} )

        @es_query ||= search_query
      end

      def node?(node_keys)
        return find_node(node_keys, es_query)
      end

      def size(size)
        es_query[:size] = size
        return self
      end

      def size?
        es_query[:size]
      end

    end
  end
end
