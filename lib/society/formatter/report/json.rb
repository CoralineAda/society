module Society
  module Formatter
    module Report
      class Json

        attr_reader :json_data, :output_path

        def initialize(json_data:, output_path: nil)
          @json_data = json_data
          @output_path = output_path
        end

        def write
          if output_path
            prepare_output_directory
            write_json_data
          else
            puts json_data
          end
        end

        private

        def timestamp
          @timestamp ||= Time.now.strftime("%Y_%m_%d_%H_%M_%S")
        end

        def prepare_output_directory
          raise "No output path was specified" if output_path.nil?
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
