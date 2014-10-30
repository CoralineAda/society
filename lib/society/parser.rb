require 'analyst'

module Society

  class Parser

    attr_reader :start_path

    def initialize(start_path)
      @start_path = start_path
    end

    def analyzer
      @analyzer ||= ::Analyst.new(self.start_path)
    end

    def class_graph
      @class_graph ||= begin
        graph = ObjectGraph.new
        graph.nodes = analyzer.classes.map do |klass|
          Node.new(
            name: klass.full_name,
            address: "", #TODO"
            edges: [] # TODO parsed_file.class_references
          )
        end
        graph
      end
    end

    # TODO pass in class name, don't assume #first
    def method_graph
      @method_graph ||= begin
        graph = ObjectGraph.new
        target = analyzer.classes.first
        graph.nodes = target.all_methods.map do |method|
          Node.new(
            name: method.name,
            address: "", #target.class_name,
            edges: [] #method.references
          )
        end
        graph
      end
    end

    def matrices(graph)
      matrix = Struct.new(:co_occurrence, :edge_bundling)
      matrix.new(
        Society::Matrix::CoOccurrence.new(graph.nodes),
        Society::Matrix::EdgeBundling.new(graph.nodes)
      )
    end

  end

end
