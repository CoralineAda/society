require 'json'
require 'pry'

module Society
  module Formatter
    module Graph
      module Core

        def self.included(klass)
          klass.send(:attr_reader, :nodes)
          klass.send(:attr_reader, :edges)
        end

        def initialize(graph)
          @nodes = graph.nodes
          @edges = graph.edges
        end

        def to_json
          to_hash.to_json
        end

      end
    end
  end
end