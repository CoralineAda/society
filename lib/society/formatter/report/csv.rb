module Society
  module Formatter
    module Report
      class CSV

        attr_reader :csv_data, :output_path

        def initialize(csv_data:, output_path: nil)
          @csv_data = csv_data
          @output_path = output_path
        end

        def write
          if output_path
            prepare_output_directory
            write_csv_data
          else
            puts csv_data
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

        def write_csv_data
          File.open(output_path, 'w') { |file| file.write csv_data }
        end
      end
    end
  end
end
