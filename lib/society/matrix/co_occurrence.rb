require 'json'
require 'pry'

module Society

  module Matrix

    class CoOccurrence

      include Society::Matrix::Core

      def to_hash
        {
          nodes: node_names.map{ |name| {name: name, group: 1} },
          links: self.nodes.map do |node|
            node.edges.map do |edge|
              next unless edge_name = node_name_symbols.index(edge) || node_names.index(edge)
              {source: node_names.index(node.name), target: edge_name, value: 1}
            end
          end.flatten.compact
        }
      end

    end

  end

end
