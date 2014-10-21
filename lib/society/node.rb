module Society
  class Node

    attr_reader   :name       # method or class name
    attr_reader   :address    # file name or file name + loc
    attr_accessor :references # relation between nodes

    def initialize(name: name, address: address, references: references=[])
      @name = name
      @address = address
      @references = references
    end

    def edges
      @edges ||= references.map do |reference|
        Edge.new(from: name, to: reference)
      end
    end

    def edge_count
      edges.count
    end

  end
end
