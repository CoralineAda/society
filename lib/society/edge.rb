module Society

  class Edge

    attr_reader :from
    attr_reader :to

    def initialize(from: from_node, to: to_node)
      @from = from
      @to = to
    end

  end

end