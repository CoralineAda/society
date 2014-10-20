require 'fileutils'

module Society

  class Parser

    attr_reader :start_path, :parsed_files

    def initialize(start_path: start_path)
      @start_path = start_path
      @parsed_files = parse_files
    end

    def object_graph
      @object_graph ||= lambda {
        graph = ObjectGraph.new
        graph.nodes = parsed_files.map do |parsed_file|
          Node.new(
            name: parsed_file.class_name,
            address: parsed_file.path_to_file,
            references: references_from(parsed_file)
          )
        end
        graph
      }.call
    end

    private

    def parse_files
      source_files.map{ |path| ParsedFile.new(path_to_file: path) }
    end

    def references_from(parsed_file)
      parsed_file.constants.select do |constant|
        parsed_files.map(&:class_name).include?(constant)
      end.reject{|constant| constant == parsed_file.class_name}
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