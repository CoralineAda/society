module Fukuzatsu

  module Formatters

    module Base

      def self.included(klass)
        klass.send(:attr_accessor, :summary)
        klass.send(:attr_accessor, :source)
        klass.send(:attr_accessor, :output_directory)
      end

      def initialize(output_directory: "./doc/fukuzatsu/", source: nil, summary:)
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

    end

  end

end
