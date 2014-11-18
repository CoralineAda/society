module Fukuzatsu

  module Formatters

    class Csv

      include Formatters::Base

      def self.writes_to_file_system?
        true
      end

      def content
        rows + "\r\n"
      end

      def export
        begin
          File.open(path_to_results, 'a') {|outfile| outfile.write(content)}
        rescue Exception => e
          puts "Unable to write output: #{e} #{e.backtrace}"
        end
      end

      def file_extension
        ".csv"
      end

      def path_to_results
        File.join(output_directory, "results#{file_extension}")
      end

      def rows
        summary.summaries.map do |summary|
          "#{summary.source_file},#{summary.container_name},#{summary.entity_name},#{summary.complexity}"
        end.join("\r\n")
      end

    end

  end
end