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
        graph.nodes = analyzer.classes.map{ |klass| klass.full_name }
        analyzer.classes.map do |klass|
          graph.edges.concat(relations_from(klass))
          graph.edges.concat(references_from(klass))
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
            edges: [] #method.references
          )
        end
        graph
      end
    end

    def formatters(graph)
      formatter = Struct.new(:heatmap, :network)
      formatter.new(
        Society::Formatter::Heatmap.new(graph),
        Society::Formatter::Network.new(graph)
      )
    end

    private

    def class_names
      @class_names ||= analyzer.classes.map(&:full_name)
    end

    def relations_from(klass)
      AssociationProcessor.new(klass).associations
    end

    def references_from(klass)
      klass.constants.map do |const|
        Edge.new from: klass.name, to: const.name
      end
    end

  end

end
