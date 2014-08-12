module Elastic
  module DSL
    module Builders
      module Queries

        module Bool
          include Elastic::DSL::Errors
          include Elastic::DSL::Builders::Utils

          def must(conditions, root_node = es_query[:query])
            add_bool_condition(:must, conditions, root_node)
          end
          def should(conditions, root_node = es_query[:query])
            add_bool_condition(:should, conditions, root_node)
          end
          def must_not(conditions, root_node = es_query[:query])
            add_bool_condition(:must_not, conditions, root_node)
          end

          private

            # Searches within root_node for a hash keyed by :bool to add or merge conditions with
            def add_bool_condition(type_key, conditions, root_node)
              return self if blank?(conditions)
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

          # def method_missing(method_sym, *args, &block)
          #   if BOOL_METHODS.include?(method_sym)
          #     return self if blank?(args[0])

          #     key_array!(args[1] ? args[1] : es_query[:query])
          #     add_bool_condition(method_sym, *args)
          #     return self

          #   else
          #     super
          #   end
          # end

          # def respond_to(method_sym, include_private = false)
          #   return BOOL_METHODS.include?(method_sym) ? true : super
          # end

          # private
          #   BOOL_METHODS = [:must, :should, :must_not]

        end

      end
    end
  end
end
