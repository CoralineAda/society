module Society
  module Formatter
    module Report
      class HTML

        attr_reader :json_data, :output_path

        def initialize(json_data:, output_path: default_output_path)
          @json_data = json_data
          @output_path = output_path
        end

        def write
          prepare_output_directory
          write_html
          write_csv
          copy_assets
          write_json_data
          puts "Results written to #{self.output_path}." unless self.output_path.nil?
        end

        private

        def default_output_path
          File.join(%w[doc society])
        end

        def write_html
          File.open(File.join(output_path, 'index.htm'), 'w') {|outfile| outfile.write(index)}
        end

        def write_csv
          File.open(File.join(output_path, 'society.csv'), 'w') {|outfile| outfile.write(csv)}
        end

        def copy_assets
          bower_dir = File.join(File.dirname(__FILE__), 'templates', 'components')
          FileUtils.cp(
            File.join(bower_dir, 'society-assets', 'society.css'),
            File.join(output_path, 'stylesheets', 'society.css')
          )
          FileUtils.cp(
            File.join(bower_dir, 'society-assets', 'society.js'),
            File.join(output_path, 'javascripts', 'society.js')
          )
          FileUtils.cp(
            File.join(bower_dir, 'd3', 'd3.min.js'),
            File.join(output_path, 'javascripts', 'd3.min.js')
          )
        end

        def index
          Haml::Engine.new(template).render(
            Object.new, json_data: json_data
          )
        end

        def csv
          Haml::Engine.new(csv_template).render(
            Object.new, json_data: json_data
          )
        end

        def csv_template
          path = File.join(File.dirname(__FILE__), 'templates', 'society.csv.haml')
          File.read(path)
        end

        def template
          path = File.join(File.dirname(__FILE__), 'templates', 'index.htm.haml')
          File.read(path)
        end

        def timestamp
          @timestamp ||= Time.now.strftime("%Y_%m_%d_%H_%M_%S")
        end

        def prepare_output_directory
          FileUtils.mkpath(File.join(output_path, 'stylesheets'))
          FileUtils.mkpath(File.join(output_path, 'javascripts'))
        end

        def write_json_data
          json_path = File.join(output_path, 'data', timestamp, 'society_graph.json')
          Formatter::Report::Json.new(json_data: json_data, output_path: json_path).write
        end
      end
    end
  end
end
