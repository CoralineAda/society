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
        graph.nodes = analyzer.classes.map{ |klass| klass.full_name }
        analyzer.classes.map do |klass|
          graph.edges.concat(relations_from(klass))
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
      formatter = Struct.new(:co_occurrence, :edge_bundling)
      formatter.new(
        Society::Formatter::CoOccurrence.new(graph),
        Society::Formatter::EdgeBundling.new(graph)
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
      []
      #throw "Implement me!"
    end
      # def add_association(method_name, args)
      #   target_class = value_from_hash_node(args.last, :class_name)
      #   target_class ||= begin
      #                      symbol_node = args.first
      #                      symbol_name = symbol_node.children.first
      #                      symbol_name.pluralize.classify
      #                    end
      #   association = Association.new(type: method_name, source: self, target_class: target_class)
      #   associations << association
      # end

      # private

      # # Fetches value from hash node iff key is symbol and value is str
      # # Raises an exception if value is not str
      # # Returns nil if key is not found
      # def value_from_hash_node(node, key)
      #   return unless node.type == :hash
      #   pair = node.children.detect do |pair_node|
      #     key_symbol_node = pair_node.children.first
      #     key == key_symbol_node.children.first
      #   end
      #   if pair
      #     value_node = pair.children.last
      #     throw "Bad type. Expected (str), got (#{value_node.type})" unless value_node.type == :str
      #     value_node.children.first
      #   end
      # end

  end

end
