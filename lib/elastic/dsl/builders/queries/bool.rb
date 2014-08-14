module Elastic
  module DSL
    module Builders
      module Queries

        module Bool
          include Elastic::DSL::Errors
          include Elastic::DSL::Builders::Utils

          # options[:append] can be used with nested nodes to force append instead of merging
          # options[:root] specifies the root node to add to

          def must(conditions, options = nil)
            options = {root: es_query[:query]}.merge!(options || {})
            add_bool_condition(:must, conditions, options)
          end
          def should(conditions, options = nil)
            options = {root: es_query[:query]}.merge!(options || {})
            add_bool_condition(:should, conditions, options)
          end
          def must_not(conditions, options = nil)
            options = {root: es_query[:query]}.merge!(options || {})
            add_bool_condition(:must_not, conditions, options)
          end

          private

            # Searches within root_node for a hash keyed by :bool to add or merge conditions with
            def add_bool_condition(type_key, conditions, options)
              return self if blank?(conditions)
              root_node = options[:root]

              if options[:append]
                # Append a new node
                raise Elastic::DSL::Errors::InvalidArgument unless root_node.is_a?(Array)
                root_node << {bool: {type_key => [conditions]}}
              else
                # Find or create bool_node
                begin
                  bool_node = find_node([:bool], root_node)
                  bool_node[type_key] = [] unless bool_node[type_key]
                rescue Elastic::DSL::Errors::NodeNotFound
                  bool_node = {type_key => []}
                  root_node.is_a?(Array) ? root_node << {bool: bool_node} : root_node[:bool] = bool_node
                end
                conditions.is_a?(Array) ? bool_node[type_key] += conditions : bool_node[type_key] << conditions
              end
            end

        end

      end
    end
  end
end
