module Elastic
  module DSL
    module Errors
      class Error < StandardError; end
      class InvalidArgument < Error; end
      class InvalidQuery < Error; end

      class NodeNotFound < Error
        attr_reader :index

        def initialize(index = nil, message = nil)
          @index = index
          @message = message
        end

        def to_s
          @message || "Could not find node at node_keys[#{index}]"
        end
      end

    end
  end
end
