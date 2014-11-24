module Society
  module Formatter
    module Report
      class Json

        attr_reader :json_data, :output_path

        def initialize(json_data:, output_path: default_output_path)
          @json_data = json_data
          @output_path = output_path
        end

        def write
          prepare_output_directory
          write_json_data
        end

        private

        def default_output_path
          File.join('doc', 'society', timestamp, 'society_graph.json')
        end

        def timestamp
          @timestamp ||= Time.now.strftime("%Y_%m_%d_%H_%M_%S")
        end

        def prepare_output_directory
          directory_path = File.split(output_path).first
          FileUtils.mkpath directory_path
        end

        def write_json_data
          File.open(output_path, 'w') { |file| file.write json_data }
        end
      end
    end
  end
end
