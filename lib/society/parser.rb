module Society

  class Parser

    attr_reader :start_paths, :scope

    def initialize(start_paths, scope=nil)
      @start_paths = start_paths
      @scope = scope
    end

    def analyzer
      @analyzer ||= ::Analyst.for_files(*start_paths)
    end

    def class_graph
      @class_graph ||= begin
        classes = analyzer.classes
        associations = associations_from(classes) + references_from(classes)
        nodes = Society::Node.from_edges(associations)
        ObjectGraph.new(nodes: nodes, edges: associations)
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
        Society::Formatter::Heatmap.new(graph, self.scope),
        Society::Formatter::Network.new(graph, self.scope)
      )
    end

    # TODO: this is dumb, cuz it depends on class_graph to be called first,
    #       but i'm just doing it for debugging right now, so LAY OFF ME
    def unresolved_edges
      {
        associations: @association_processor.unresolved_associations,
        references: @reference_processor.unresolved_references
      }
    end

    def all_the_data
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

