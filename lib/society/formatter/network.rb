require 'json'
require 'pry'

module Society

  module Formatter

    class Network

      include Society::Formatter::Core

      def to_json
        node_names.map do |name|
          {
            name: name,
            edges: named_edges.select { |edge| edge.from == name }.map(&:to)
          }
        end.to_json
      end

      def node_names
        nodes.map(&:full_name).uniq
      end

      def named_edges
        @named_edges ||= edges.map { |edge| Edge.new(from: edge.from.full_name, to: edge.to.full_name) }
      end

    end

  end

end

# [
#   { name: "Foo", edges: ["Bar"] },
#   { name: "Bar", edges: ["Foo", "Baz"] },
#   { name: "Baz", edges: [] },
# ]
