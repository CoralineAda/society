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
          write_json_data
        rescue Exception => e
          puts "Unable to write output: #{e} #{e.backtrace}"
        end

        private

        def timestamp
          Time.now.strftime("%Y_%m_%d_%H_%M_%S")
        end

        def reset_output_directory
          FileUtils.mkpath(data_directory)
          FileUtils.mkpath("#{data_directory}/data/#{timestamp}")
        end

        def write_json_data
          json_directory = "#{data_directory}/data/#{timestamp}"
          File.open(File.join(json_directory, 'heatmap.json'), 'w') do |file|
            file.write heatmap_json
          end
          File.open(File.join(json_directory, 'network.json'), 'w') do |file|
            file.write network_json
          end
        end

      end
    end
  end
end