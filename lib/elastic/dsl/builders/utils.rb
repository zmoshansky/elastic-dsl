module Elastic
  module DSL
    module Builders
      module Utils

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
        def find_node(node_keys, root_node)
          raise ArgumentError.new('node_keys blank') if blank?(node_keys)
          # raise ArgumentError.new('root_node must be of type hash_with_indifferent_access') unless root_node.is_a?(HashWithIndifferentAccess)
          node_keys = key_to_array(node_keys)

          node_keys.each_with_index do |k, index|
            if root_node.is_a?(Array)
              temp = root_node.find { |i| i.key?(k) }
              raise Elastic::DSL::Errors::NodeNotFound.new(index) unless temp
              root_node = temp[k]
            else
              root_node = root_node[k]
            end
            raise Elastic::DSL::Errors::NodeNotFound.new(index) unless root_node
          end

          return root_node
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