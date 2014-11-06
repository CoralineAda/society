require 'json'
require 'pry'

module Society

  module Formatter

    class Heatmap

      include Society::Formatter::Core

      def to_hash
        {
          nodes: nodes.map { |node| {name: node.full_name, group: 1} },
          links: edges.map do |edge|
            {
              source: nodes.index(edge.from),
              target: nodes.index(edge.to),
              value: 1
            }
          end
        }
      end

    end

  end

end
