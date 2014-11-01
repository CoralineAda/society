module Fukuzatsu
  class FileReader

    attr_reader :path_to_files

    def initialize(path_to_files)
      @path_to_files = path_to_files
    end

    def source_files
      file_list.map{ |file_path| SourceFile.new(file_path) }
    end

    private

    def file_list
      if File.directory?(path_to_files)
        return Dir.glob(File.join(path_to_files, "**", "*.rb"))
      else
        return [path_to_files]
      end
    end

    class SourceFile
      attr_reader :file
      def initialize(file)
        @file = File.open(file, "r")
      end
      def filename
        file.path
      end
      def contents
        self.file.read
      end
    end

  end
end
