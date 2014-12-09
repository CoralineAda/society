module Society

  class ObjectGraph

    attr_accessor :nodes, :edges

    def initialize(nodes: nodes=[], edges: edges=[])
      @nodes = nodes
      @edges = edges
    end

  end

end
