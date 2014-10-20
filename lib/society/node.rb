module Society

  class Node

    attr_reader   :name     # method or class name
    attr_reader   :address  # file name or file name + loc
    attr_accessor :edges    # relation between nodes

    def initialize(name: name, address: address, edges: edges=[])
      @edges = edges
      @name = name
      @address = address
    end

    def edge_count
      edges.count
    end

  end

end