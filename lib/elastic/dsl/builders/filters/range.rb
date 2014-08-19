module Elastic
  module DSL
    module Builders
      module Filters

        module Range
          include Elastic::DSL::Errors
          include Elastic::DSL::Builders::Utils

          def range(field, options = {root: es_query[:filter]})
            return self if blank?(field, options, options[:root])
            root_node = options[:root]

            root_node[:range]
          end
        end

      end
    end
  end
end
