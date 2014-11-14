require 'json'
require 'pry'

module Society

  module Formatter

    class Network

      include Society::Formatter::Core

      def to_json
        self.nodes.map do |node|
          {
            name: node.name,
            edges: node.edges.map{|e| e.to.full_name }
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
