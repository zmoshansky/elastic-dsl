module Elastic
  module DSL
    module Errors
      class BaseError < Exception; end

      class NodeNotFound < Elastic::DSL::Errors::BaseError
        attr_accessor :index

        def intialize(index)
          @index = index
        end
      end

    end
  end
end
