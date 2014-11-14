module Society

  class Node

    include ::Ephemeral::Base
    collects :edges, class_name: "Society::Edge"

    attr_reader :name

    def self.from_edges(edges)
      names = (edges.map(&:from) + edges.map(&:to)).uniq
      names.map do |connection|
        new(
          name: connection.full_name,
          edges: edges.select{|e| e.from.full_name == connection.full_name || e.to.full_name == connection.full_name})
      end
    end

    def initialize(name:, edges:[])
      @name = name
      self.edges = edges
    end

    # TODO fixme remove
    def full_name
      self.name
    end

  end

end
