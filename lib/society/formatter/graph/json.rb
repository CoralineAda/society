require 'json'

module Society
  module Formatter
    module Graph
      class JSON

        def initialize(graph)
          @graph = graph
        end

        def to_json
          to_hash.to_json
        end

        def to_hash
          {
            nodes: node_names.map do |name|
              {
                name: name,
                couplings: named_edges.select { |edge| edge.from == name }
                  .map(&:to)
              }
            end,
            # edges: named_edges.map do |edge|
            #   {
            #     from: node_names.index(edge.from),
            #     to: node_names.index(edge.to)
            #   }
            # end,
            clusters: clusters_of_indices
          }
        end

        private

        attr_reader :graph

        def node_names
          @node_names ||= graph.nodes.map(&:full_name).uniq
        end

        def named_edges
          @named_edges ||= graph.edges.map { |edge| Edge.new(from: edge.from.full_name, to: edge.to.full_name) }
        end

        def clusters_of_indices
          Society::Clusterer.new.cluster(graph_of_names).map do |cluster|
            cluster.map { |name| node_names.index(name) }
          end
        end

        def graph_of_names
          ObjectGraph.new(nodes: node_names, edges: named_edges)
        end

      end
    end
  end
end
