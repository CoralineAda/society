require 'json'
require 'pry'

module Society

  module Matrix

    class EdgeBundling

      include Society::Matrix::Core

      def to_json
        nodes.map do |node|
          {
            name: node.name,
            edges: node.edges.uniq.select{ |n| node_names.include? n }
          }
        end.to_json
      end

    end

  end

end
