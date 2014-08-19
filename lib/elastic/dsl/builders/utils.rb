module Elastic
  module DSL
    module Builders
      module Utils
        include Elastic::DSL::Errors

        def deeper_merge(this_hash, other_hash, key, &block)
          deeper_merge!(this_hash.dup, other_hash, key, &block)
        end

        # http://apidock.com/rails/v4.0.2/Hash/deep_merge%21
        def deeper_merge!(this_hash, other_hash, key, &block)
          other_hash.each_pair do |k,v|
            tv = this_hash.is_a?(Array) ? this_hash : this_hash[k]

            if tv.is_a?(Array) && v.is_a?(Array)
              tv_bool_root = tv.find { |i| i.key?(key)}
              v_bool_root = v.find { |i| i.key?(key)}

              if tv_bool_root && v_bool_root
                v.delete(v_bool_root)
                deeper_merge!(tv_bool_root, v_bool_root, key, &block)
              end
              this_hash[k] = tv | v
            elsif tv.is_a?(Hash) && v.is_a?(Hash)
              deeper_merge!(tv, v, key, &block)
            else
              this_hash[k] = block && tv ? block.call(k, tv, v) : v
            end
          end
          this_hash
        end

        # Accepts a single or list of keys and starts searching at root_node
        # Returns the value a node maps to like a hash accessor (a_hash[:test])
        # Raises an exception otherwise, exception needed to allow the return of nil, false
        def find_node(node_keys, root_node)
          raise Elastic::DSL::Errors::InvalidArgument, 'node_keys blank' if blank?(node_keys)
          # raise ArgumentError, 'root_node must be of type hash_with_indifferent_access' unless root_node.is_a?(HashWithIndifferentAccess)
          node_keys = key_to_array(node_keys)

          node_keys.each_with_index do |k, index|
            if root_node.is_a?(Array)
              temp = root_node.find do |i|
                raise Elastic::DSL::Errors::InvalidQuery, 'Only hashes are allowed in es_query arrays' unless i.is_a?(Hash)
                i.key?(k)
              end
              raise Elastic::DSL::Errors::NodeNotFound.new(index, "node '#{node_keys[index]}' was not found at node_keys[#{index}]") unless temp
              root_node = temp[k]
            else
              raise Elastic::DSL::Errors::NodeNotFound.new(index, "node '#{node_keys[index]}' was not found at node_keys[#{index}]") unless root_node.key?(k)
              root_node = root_node[k]
            end
          end
          return root_node
        end

        # Finds or creates the nodes specified and returns the parent of the last key
        # TODO find better way of passing values than node_keys to allow creation of arrays
        # Ideally allow for objects to be searched for too
        def foc_node!(node_keys, root_node, node)
          parent = find_node(node_keys, root_node)
        rescue Elastic::DSL::Errors::NodeNotFound => e
          parent = find_node(node_keys[0..e.index-1], root_node)
          parent = create_nodes!(node_keys[e.index-1..-2], parent)
          parent[node_keys[-1]] = node
        end

        # creates the nodes overwriting any old ones, returning the parent node of the last key
        def create_nodes!(node_keys, parent)
          last_parent = nil
          p = Proc.new do |key|
            last_parent = parent
            parent = parent[key] = {}
          end

          node_keys.each &p
          return last_parent
        end

        def blank?(*objs)
          objs.each do |obj|
            return false unless blank_?(obj)
          end
          return true
        end

        def key_to_array(node_keys)
          node_keys.respond_to?(:each_with_index) ? node_keys : [node_keys]
        end

        private
          def blank_?(obj)
            return blank?(*obj) if obj.class == Array && !obj.empty?
            return obj.respond_to?(:empty?) ? !!obj.empty? : !obj
          end

      end
    end
  end
end