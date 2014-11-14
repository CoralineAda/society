module Society

  class Node

    include ::Ephemeral::Base
    collects :edges, class_name: "Society::Edge"

    attr_reader :name

    def self.from_edges(edges)
      origin_names = edges.map(&:from).uniq
      destination_names = origin_names - edges.map(&:to).uniq
      (origin_names + destination_names).map do |connection|
        new(name: connection, edges: edges.select{|e| e.from == connection || e.to == connection})
      end
    end

    def initialize(name:, edges:[])
      @name = name
      self.edges = edges
    end

  end

end
