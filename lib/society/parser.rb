module Society

  class Parser

    attr_reader :start_path

    def initialize(start_path)
      @start_path = start_path
    end

    def analyzer
      @analyzer ||= ::Analyst.for_files(self.start_path)
    end

    def class_graph
      @class_graph ||= begin
        classes = analyzer.classes
        associations = associations_from(classes) + references_from(classes)
        # TODO: merge identical classes, and (somewhere else) deal with
        #       identical associations too. need a WeightedEdge, and each
        #       one will be unique on [from, to], but will have a weight

        ObjectGraph.new(nodes: classes, edges: associations)
      end
    end

    # TODO pass in class name, don't assume #first
    def method_graph
      # @method_graph ||= begin
      #   graph = ObjectGraph.new
      #   target = analyzer.classes.first
      #   graph.nodes = target.all_methods.map do |method|
      #     Node.new(
      #       name: method.name,
      #       edges: [] #method.references
      #     )
      #   end
      #   graph
      # end
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

    def associations_from(all_classes)
      @association_processor ||= AssociationProcessor.new(all_classes)
      @association_processor.associations
    end

    def references_from(all_classes)
      @reference_processor ||= ReferenceProcessor.new(all_classes)
      @reference_processor.references
    end

  end

end
