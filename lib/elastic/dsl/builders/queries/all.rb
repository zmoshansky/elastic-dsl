require 'elastic/dsl/builders/queries/bool'

module Elastic
  module DSL
    module Builders
      module Queries

        module All
          include Elastic::DSL::Builders::Queries::Bool
        end

      end
    end
  end
end
