module Society
  class Node

    attr_reader   :name       # method or class name
    attr_accessor :edges      # relation between nodes

    def initialize(name: name, edges: edges=[])
      @name = name
      @edges = edges
    end

    def edge_count
      edges.count
    end

  end
end
