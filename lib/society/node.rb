module Society

  # The Node class represents a single node in a graph.  In this case, nodes
  # are assumed to be either Classes or Modules.
  class Node

    attr_reader :name, :type, :edges, :unresolved, :meta

    # Public: Creates a new node.
    #
    # name       - Name to be assigned to the node.  Assumed to be a Class or
    #              Module name.
    # type       - Type of node.  Assumed to be :class or :module.
    # edges      - Edges which point to other nodes.
    # unresolved - References to nodes which have not yet been resolved.
    #              (default: [])
    # meta       - Information to be tracked about the node itself.
    #              (default: [])
    def initialize(name:, type:, edges: [], unresolved: [], meta: [])
      @name       = name
      @type       = type
      @edges      = edges
      @unresolved = unresolved
      @meta       = meta
    end

    # Public: Reports whether another node intersects.
    # Nodes are considered to be intersecting if their name and type are equal.
    #
    # node - Another Node.
    #
    # Returns true or false.
    def intersects?(node)
      node.name == name && node.type == type
    end

    # Public: Create a node representing the sum of the current node and
    # another, intersecting node.
    #
    # node - Another node object.
    #
    # Returns self if self is passed.
    # Returns nil if the nodes do not intersect.
    # Returns a new node containing the sum of both nodes' edges otherwise.
    def +(node)
      return self if self == node
      return nil unless self.intersects?(node)

      new_edges      = accumulate_edges(edges, node.edges)
      new_unresolved = accumulate_edges(unresolved, node.unresolved)
      new_meta       = meta + node.meta

      return Node.new(name: name, type: type, edges: new_edges,
                      unresolved: new_unresolved, meta: new_meta)
    end

    # Public: Return the name of the node.
    #
    # Returns a string.
    def to_s
      name.to_s
    end
    alias_method :inspect, :to_s

    private

    # Internal: Reduce two lists of edges to a single list with equivalent
    # edges summed.
    #
    # edges_a - Array of Edges.
    # edges_b - Array of Edges.
    #
    # Returns an array of Edges.
    def accumulate_edges(edges_a, edges_b)
      new_edges = (edges_a + edges_b).flatten.reduce([]) do  |edges, edge|
        if edges.detect { |e| e.to == edge.to }
          edges.map { |e| e + edge || e }
        else
          edges + [edge]
        end
      end
    end

  end

end
