require 'fileutils'

module Society

  class Parser

    attr_reader :start_path, :parsed_files

    def initialize(start_path: start_path)
      @start_path = start_path
      @parsed_files = parse_files
    end

    private

    def parse_files
      source_files.map{ |path| ParsedFile.new(path_to_file: path) }
    end

    def source_files
      if File.directory?(start_path)
        return Dir.glob(File.join(start_path, "**", "*.rb"))
      else
        return [start_path]
      end
    end

  end

end