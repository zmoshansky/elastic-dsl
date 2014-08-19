require 'elastic/dsl/builders/filters/geo'

module Elastic
  module DSL
    module Builders
      module Filters

        module All
          include Elastic::DSL::Builders::Filters::Geo
        end

      end
    end
  end
end
