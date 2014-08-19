module Elastic
  module DSL
    module Builders
      module Filters

        module Range
          include Elastic::DSL::Errors
          include Elastic::DSL::Builders::Utils

          def range(field, options = nil)
            return self if blank?(field, options, options[:root])
            options = {root: es_query[:query]}.merge!(options || {})

            root_node = options[:root]
            # binding.pry
            foc_node!([:range, field], root_node, nil)
            root_node[:range, field] = options[:range]
          end
        end

      end
    end
  end
end
