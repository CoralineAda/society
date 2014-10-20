module Society

  class Edge

    attr_reader :from_node
    attr_reader :to_node
    attr_reader :relation

    def initialize(from_node: from_node, to_node: to_node, relation: relation)
      @from_node  = from_node
      @to_node    = to_node
      @relation   = relation
    end

  end

end