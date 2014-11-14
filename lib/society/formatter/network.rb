require 'json'
require 'pry'

module Society

  module Formatter

    class Network

      include Society::Formatter::Core


      def to_json
        if scope
          nodes_to_map = self.nodes.select{|n| n.edges.about(scope).present? }
        else
          nodes_to_map = self.nodes
        end
        nodes.map do |node|
          edges = scope ? node.edges.about(scope) : node.edges
          {
            name: node.name,
            edges: edges.map{|e| e.to.full_name}
          }
        end.to_json
      end

    end

  end

end
