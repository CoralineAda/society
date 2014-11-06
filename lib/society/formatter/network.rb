require 'json'
require 'pry'

module Society

  module Formatter

    class Network

      include Society::Formatter::Core

      def to_json
        self.nodes.map do |node|
          {
            name: node.full_name,
            edges: self.edges.select { |edge| edge.from == node }
                             .map { |edge| edge.to.full_name }
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
