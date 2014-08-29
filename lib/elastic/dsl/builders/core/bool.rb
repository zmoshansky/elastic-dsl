module Elastic
  module DSL
    module Builders
      module Core

        module Bool
          include Elastic::DSL::Errors
          include Elastic::DSL::Builders::Utils

          # options[:append] can be used with nested nodes to force append instead of merging
          # options[:filter] if set to true will create filter, default is query
          # options[:root] specifies the root node to add to, overrides filter
          def must(conditions, options = nil)
            options = process_bool_options!(options)
            add_bool_condition(:must, conditions, options)
          end
          def should(conditions, options = nil)
            options = process_bool_options!(options)
            add_bool_condition(:should, conditions, options)
          end
          def must_not(conditions, options = nil)
            options = process_bool_options!(options)
            add_bool_condition(:must_not, conditions, options)
          end

          # Use this to create searchers where one of a group of conditions should be true
          # Creates a should statement nested under a must bool, helpful for multiple OR groups
          # ex.) should       - c || d || e || f
          # ex.) one_of_these - (c || d) && (e || f)
          def one_of_these(conditions, options = nil)
            options = process_bool_options!(options)
            options[:root][:bool] = {} unless options[:root][:bool]
            options[:root][:bool][:must] = [] unless options[:root][:bool][:must]
            options[:root] = options[:root][:bool][:must]

            options[:append] = true
            add_bool_condition(:should, conditions, options)
          end

          private
            # Sets some sane defaults
            def process_bool_options!(options)
              options ||= {}
              default_root = options[:filter] ? es_query[:filter] : es_query[:query]
              options = {root: default_root}.merge!(options)
            end

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
