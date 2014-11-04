module Fukuzatsu

  module Formatters

    module Base

      def self.included(klass)
        klass.send(:attr_accessor, :summaries)
        klass.send(:attr_accessor, :source)
        klass.send(:attr_accessor, :output_directory)
      end

      def initialize(output_directory: nil, source: nil, summaries:)
        self.source = source
        self.summaries = summaries
        self.output_directory = output_directory
      end

      def filename
        File.basename(self.file.path_to_file) + file_extension
      end

      def output_path
        output_path = File.dirname(File.join(self.output_directory, self.file.path_to_file))
        FileUtils.mkpath(output_path)
        output_path
      end

      def path_to_results
        File.join(output_path, filename)
      end

    end

  end

end
