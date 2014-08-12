module Elastic
  module DSL
    module Builders
      module Filters

        module Geo
          include Elastic::DSL::Errors
          include Elastic::DSL::Builders::Utils

          def geo_distance(lat, lon, distance, root_node = es_query[:filter])
            if root_node.nil? && es_query[:filter].nil?
              root_node = es_query[:filter] = {}
            end

            root_node[:geo_distance] = {
              distance: distance,
              'location' => {
                lat: lat,
                lon: lon
              }
            }
          end
        end

      end
    end
  end
end
