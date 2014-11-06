require 'json'
require 'pry'

module Society

  module Formatter

    class Heatmap

      include Society::Formatter::Core

      def to_hash
        node_names = nodes.map { |name| {name: name, group: 1} }
        links = []
        missing = { sources: [], targets: [] }

        edges.each do |edge|
          source = nodes.index(edge.from)
          target = nodes.index(edge.to)

          if source.present? && target.present?
            links << { source: source, target: target, value: 1 }
          else
            missing[:sources] << edge.from if source.blank?
            missing[:targets] << edge.to if target.blank?
          end
        end

        { nodes: node_names, links: links, missing: missing }
      end

    end

  end

end
