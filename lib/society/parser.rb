require 'fileutils'

module Society

  class Parser

    attr_reader :path_to_files, :parsed_files

    def initialize(path_to_files: path_to_files)
      @path_to_files = path_to_files
      @parsed_files = parse_files
    end

    def class_graph
      @class_graph ||= begin
        graph = ObjectGraph.new
        graph.nodes = parsed_files.map do |parsed_file|
          Node.new(
            name: parsed_file.class_name,
            address: parsed_file.path_to_file,
            references: parsed_file.class_references
          )
        end
        graph
      end
    end

    def method_graph
      @method_graph ||= begin
        graph = ObjectGraph.new
        target = parsed_files.first
        graph.nodes = target.methods.map do |method|
          Node.new(
            name: method.name,
            address: target.class_name,
            references: method.references
          )
        end
        graph
      end
    end

    def matrix(graph)
      Matrix.new(graph.nodes)
    end

    private

    def parse_files
      source_files.map{ |path| ParsedFile.new(path_to_file: path) }
    end

    def source_files
      if File.directory?(path_to_files)
        return Dir.glob(File.join(path_to_files, "**", "*.rb"))
      else
        return [path_to_files]
      end
    end

  end

end