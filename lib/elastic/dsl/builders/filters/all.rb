require 'elastic/dsl/builders/filters/geo'
require 'elastic/dsl/builders/filters/range'

module Elastic
  module DSL
    module Builders
      module Filters

        module All
          include Elastic::DSL::Builders::Filters::Geo
          include Elastic::DSL::Builders::Filters::Range
        end

      end
    end
  end
end
