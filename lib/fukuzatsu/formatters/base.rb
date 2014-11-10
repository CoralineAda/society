module Fukuzatsu

  module Formatters

    module Base

      BASE_OUTPUT_DIRECTORY = "doc/fukuzatsu/"

      def self.included(klass)
        klass.send(:attr_accessor, :summary)
        klass.send(:attr_accessor, :source)
        klass.extend(ClassMethods)
      end

      def initialize(source: nil, summary:nil)
        self.source = source
        self.summary = summary
      end

      def output_directory
        BASE_OUTPUT_DIRECTORY + file_extension.gsub(".","")
      end

      def filename
        File.basename(self.summary.source_file) + file_extension
      end

      def output_path
        output_path = File.dirname(File.join(output_directory, self.summary.source_file))
        FileUtils.mkpath(output_path)
        output_path
      end

      def path_to_results
        File.join(output_path, filename)
      end

      module ClassMethods

        def explain(count)
          puts "Processed #{count} file(s)."
        end

        def index(summaries)
        end

        def reset_output_directory
          directory = new.output_directory
          begin
            FileUtils.remove_dir(directory)
          rescue Errno::ENOENT
          end
          FileUtils.mkpath(directory)
        end

      end
    end

  end

end
