require 'json'

module Society
  module Formatter
    module Report
      class Json

        attr_reader :heatmap_json, :network_json, :data_directory

        def initialize(heatmap_json:, network_json:, data_directory:)
          @heatmap_json = heatmap_json
          @network_json = network_json
          @data_directory = data_directory
        end

        def write
          reset_output_directory
          write_headmap_json
          write_network_json
        end

        private

        def reset_output_directory
          begin
            FileUtils.remove_dir(data_directory)
          rescue Errno::ENOENT
          end
          FileUtils.mkpath(data_directory)
        end

        def write_heatmap_json
          file = File.open(File.join(data_directory, 'heatmap.json'), 'w')
          file.write heatmap_json
          file.close
        end

        def write_network_json
          file = File.open(File.join(data_directory, 'network.json'), 'w')
          file.write network_json
          file.close
        end

      end
    end
  end
end