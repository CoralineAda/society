require 'json'

module Society
  module Formatter
    module Graph
      class JSON

        def initialize(graph)
          @nodes = graph.nodes
          @edges = graph.edges
        end

        def to_json
          {
            nodes: node_names.map { |name| { name: name } },
            edges: named_edges.map do |edge|
              {
                from: node_names.index(edge.from),
                to: node_names.index(edge.to)
              }
            end
          }.to_json
        end

        private

        attr_reader :nodes, :edges

        def node_names
          @node_names ||= nodes.map(&:full_name).uniq
        end

        def named_edges
          @named_edges ||= edges.map { |edge| Edge.new(from: edge.from.full_name, to: edge.to.full_name) }
        end

      end
    end
  end
end
