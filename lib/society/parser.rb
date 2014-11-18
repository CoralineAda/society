module Society

  class Parser

    def self.for_files(*file_paths)
      new(::Analyst.for_files(*file_paths))
    end

    def self.for_source(source)
      new(::Analyst.for_source(source))
    end

    attr_reader :analyzer

    def initialize(analyzer)
      @analyzer = analyzer
    end

    def class_graph
      @class_graph ||= begin
        classes = analyzer.classes
        associations = associations_from(classes) + references_from(classes)
        ObjectGraph.new(nodes: classes, edges: associations)
      end
    end

    def graph_formatters(graph)
      {
        heatmap: Society::Formatter::Heatmap.new(graph),
        network: Society::Formatter::Network.new(graph)
      }
    end

    def heatmap_json
      heatmap_json = parser.formatters(class_graph).heatmap.to_json
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

    def network_json
      network_json = parser.formatters(class_graph).network.to_json
    end

    # TODO: this is dumb, cuz it depends on class_graph to be called first,
    #       but i'm just doing it for debugging right now, so LAY OFF ME
    def unresolved_edges
      {
        associations: @association_processor.unresolved_associations,
        references: @reference_processor.unresolved_references
      }
    end

    def debug
      {
        classes: analyzer.classes,
        resolved: {
          associations: @association_processor.associations,
          references: @reference_processor.references
        },
        unresolved: unresolved_edges,
        stats: {
          resolved_associations: @association_processor.associations.size,
          unresolved_associations: @association_processor.unresolved_associations.size,
          resolved_references: @reference_processor.references.size,
          unresolved_references: @reference_processor.unresolved_references.size
        }
      }
    end

    def class_names
      @class_names ||= analyzer.classes.map(&:full_name)
    end

    private

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

