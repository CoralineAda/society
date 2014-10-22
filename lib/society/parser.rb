require 'fukuzatsu'

module Society

  class Parser < Fukuzatsu::Parser

    attr_reader :parsed_files

    def initialize(start_path)
      super(start_path, :none, 0)
      @parsed_files = parse_files
    end

    def class_graph
      @class_graph ||= begin
        graph = ObjectGraph.new
        graph.nodes = parsed_files.map do |parsed_file|
          Node.new(
            name: parsed_file.class_name,
            address: parsed_file.path_to_file,
            edges: parsed_file.class_references
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
            edges: method.references
          )
        end
        graph
      end
    end

    def matrix(graph)
      Society::Matrix.new(graph.nodes)
    end

    def reset_output_directory
    end

  end

end
