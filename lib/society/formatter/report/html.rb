require 'json'

module Society
  module Formatter
    module Report
      class HTML

        attr_reader :heatmap_json, :network_json, :data_directory

        def initialize(heatmap_json:, network_json:, data_directory:)
          @heatmap_json = heatmap_json
          @network_json = network_json
          @data_directory = ("./#{data_directory}/").gsub("//","/")
        end

        def write
          reset_output_directory
          File.open("#{data_directory}index.htm", 'w') {|outfile| outfile.write(index)}
          copy_assets
          write_json_data
        rescue Exception => e
          puts "Unable to write output: #{e} #{e.backtrace}"
        end

        private

        def copy_assets
          FileUtils.cp(
            File.dirname(__FILE__) + "/templates/css/style.css",
            "#{data_directory}css/style.css"
          )
          FileUtils.cp(
            File.dirname(__FILE__) + "/templates/js/heatmap.js",
            "#{data_directory}js/heatmap.js"
          )
          FileUtils.cp(
            File.dirname(__FILE__) + "/templates/js/network.js",
            "#{data_directory}js/network.js"
          )
        end

        def index
          Haml::Engine.new(template).render(
            Object.new, {
              heatmap_path: "data/#{timestamp}/heatmap.json",
              network_path: "data/#{timestamp}/network.json"
           }
          )
        end

        def template
          File.read(File.dirname(__FILE__) + "/templates/index.htm.haml")
        end

        def timestamp
          Time.now.strftime("%Y_%m_%d_%H_%M_%S")
        end

        def reset_output_directory
          begin
            FileUtils.remove_dir(data_directory)
          rescue Errno::ENOENT
          end
          FileUtils.mkpath(data_directory)
          FileUtils.mkpath("#{data_directory}/css")
          FileUtils.mkpath("#{data_directory}/data/#{timestamp}")
          FileUtils.mkpath("#{data_directory}/js")
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