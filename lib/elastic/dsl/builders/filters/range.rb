module Elastic
  module DSL
    module Builders
      module Filters

        module Range
          include Elastic::DSL::Errors
          include Elastic::DSL::Builders::Utils

          def range(field, options = nil)
            return self if blank?(field, options, options[:root])
            options = {root: es_query[:filter]}.merge!(options || {})
            root_node = options[:root]

            parent = foc_node!([:filter, :range, field], root_node, nil)

            # parent = foc_node_parent_from_hash!({filter: {range: {field => options.select {|k,v| [:gte, :gt, :lte, :lt].include?(k)} }}}, root_node)
            # binding.pry

            # root_node[:range, field] = options[:range]
          end

        end

      end
    end
  end
end
