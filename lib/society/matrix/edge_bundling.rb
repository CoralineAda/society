require 'json'
require 'pry'

module Society

  module Matrix

    class EdgeBundling

      include Society::Matrix::Core

      def to_json
        self.nodes.map do |node|
          {
            name: node,
            edges: self.edges.select{|edge| edge.from == node}.map(&:to).select do |edge|
              self.nodes.include?(edge)
            end
          }
        end.to_json
      end

    end

  end

end

# [
#   { name: "Foo", edges: ["Bar"] },
#   { name: "Bar", edges: ["Foo", "Baz"] },
#   { name: "Baz", edges: [] },
# ]