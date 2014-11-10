module Fukuzatsu

  module Formatters

    module Base

      DEFAULT_OUTPUT_DIRECTORY = "doc/fukuzatsu/"

      def self.included(klass)
        klass.send(:attr_accessor, :summary)
        klass.send(:attr_accessor, :source)
        klass.send(:attr_accessor, :output_directory)
        klass.extend(ClassMethods)
      end

      def initialize(output_directory: "./#{DEFAULT_OUTPUT_DIRECTORY}", source: nil, summary:)
        self.source = source
        self.summary = summary
        self.output_directory = output_directory
      end

      def filename
        File.basename(self.summary.source_file) + file_extension
      end

      def output_path
        output_path = File.dirname(File.join(self.output_directory, self.summary.source_file))
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

      end
    end

  end

end
