module Society
  module Formatter
    module Report
      class Json

        attr_reader :json_data, :output_path

        def initialize(json_data:, output_path:)
          @json_data = json_data
          @output_path = output_path
        end

        def write
          create_output_directory
          write_json_data
        end

        private

        def create_output_directory
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
