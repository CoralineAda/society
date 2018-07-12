module Society

  # The ObjectGraph class represents a graph of interrelated nodes as an Array
  # of nodes which can be iterated over.
  class ObjectGraph < Array

    # Public: Override Array#initialize, accepting any number of nodes and
    # lists of nodes including other ObjectGraphs to create a single graph from
    # them.
    #
    # nodes - Any number of nodes or lists of nodes.
    def initialize(*nodes)
      super(nodes.flatten)
    end

    # Public: Add two graphs together, returning a new ObjectGraph containing
    # the sum of all nodes contained in both.
    #
    # other - Another graph.
    #
    # Returns an ObjectGraph.
    def +(other)
      other.reduce(self) do |graph, node|
        if graph.select { |n| n.intersects?(node) }.any?
          Society::ObjectGraph.new(graph.map { |n| n + node || n  })
        else
          Society::ObjectGraph.new(graph, node)
        end
      end
    end

    # Public: Create a new graph, adding another node.
    #
    # node - Node to be added to the new graph.
    #
    # Returns an ObjectGraph.
    def <<(node)
      self + Society::ObjectGraph.new(node)
    end
    alias_method :push, :<<

    # Public: Return the graph represented as a Hash.
    #
    # Returns a hash.
    def to_h
      self.reduce({}) do |hash, node|
        hash.merge({ node.name => node.edges })
      end
    end

    # Public: Return the graph as a JSON string.
    #
    # Returns a string.
    def to_json
      to_h.reduce({}) do |hash, node|
        name, edges_raw = node
        edges = edges_raw.reduce({}) do |edges, edge|
          edges.merge({ edge.to => edge.weight })
        end
        hash.merge({ name => edges })
      end.to_json
    end

  end

end
