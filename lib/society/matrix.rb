require 'json'

module Society

  class Matrix

    attr_reader :nodes

    def initialize(nodes)
      @nodes = nodes
    end

    def to_json
      { names: node_names, matrix: matrix }.to_json
    end

    private

    def node_names
      self.nodes.map(&:name)
    end

    def matrix
      reference_matrix = [[]]
      nodes.each_with_index do |node, i|
        references = node_names.map do |name|
          node.edges.include?(name) ? 1 : 0
        end
        reference_matrix.push(references)
      end
      reference_matrix
    end

  end

end