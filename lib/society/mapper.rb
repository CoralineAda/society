require 'graphviz'
require 'json'

module Society
  class Mapper

    attr_reader :node_graph

    LINE_HEIGHT = 10

    def initialize(node_graph)
      @node_graph = node_graph
    end

    def graph
      @graph ||= GraphViz.new(:G, type: :digraph, ratio: :auto, ranksep: 3)
    end

    def write
      draw_nodes
      graph.output(svg: "#{path_to_file}.svg")
      graph.output(dot: "#{path_to_file}.dot")
    end

    def generate_d3_data
      nodeNames = []
      dep_matrix = [[]]
      nodeNames = sorted_nodes.map(&:name)
      sorted_nodes.each_with_index do |node, i|
        dependencies = nodeNames.map do |name|
          node.references.include?(name) ? 1 : 0
        end
        dep_matrix.push(dependencies)
      end
      { packageNames: nodeNames, matrix: dep_matrix }.to_json
    end

    private

    def path_to_file
      "./graph.dot"
    end

    def sorted_nodes
      nodes = self.node_graph.nodes
      nodes = nodes.reject{ |node| node.references.empty? || node.name.empty? }
      nodes = nodes.sort{ |a,b| a.name.split('::').last.length <=> b.name.split('::').last.length }
      nodes.compact
    end

    def draw_nodes
      graph_nodes = {}
      sorted_nodes.map(&:name).each do |name|
        graph_nodes[name] = graph.add_nodes(name)
      end
      sorted_nodes.each do |node|
        node.references.uniq.each do |reference|
          next unless reference && graph_nodes[reference] && graph_nodes[node.name]
          graph.add_edges(graph_nodes[node.name], graph_nodes[reference])
        end
      end
    end

  end
end