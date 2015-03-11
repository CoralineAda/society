module Society

  # The Edge class represents an edge between two nodes in a graph.  An edge is
  # assumed to represent a direct relationship between two Classes or Modules.
  class Edge

    attr_reader :to, :weight

    # Public: Create a new Edge.
    #
    # to     - Node to target.
    # weight - Weight of the edge, representing the number of references to the
    #          node referenced.  (Default: 1)
    def initialize(to:, weight: 1)
      @to     = to
      @weight = weight
    end

    # Public: Add two Edges' weights, returning a new Edge.
    #
    # edge - An Edge.
    #
    # Returns a new Edge if both edges target the same node.
    # Returns nil otherwise.
    def +(edge)
      return nil unless edge.to == to

      Edge.new(to: to, weight: weight + edge.weight)
    end

    # Public: Return the name of the node to which the edge points.
    #
    # Returns a string.
    def to_s
      to.to_s
    end
    alias_method :inspect, :to_s

  end

end
