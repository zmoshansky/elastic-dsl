module Elastic
  module DSL
    module Errors
      class BaseError < StandardError; end
      class InvalidArgument < BaseError; end

      class InvalidQuery < Elastic::DSL::Errors::BaseError; end
      class NodeNotFound < Elastic::DSL::Errors::BaseError; end
    end
  end
end
