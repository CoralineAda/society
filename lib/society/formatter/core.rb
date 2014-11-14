require 'json'
require 'pry'

module Society

  module Formatter

    module Core

      def self.included(klass)
        klass.send(:attr_reader, :nodes)
        klass.send(:attr_reader, :edges)
        klass.send(:attr_reader, :scope)
      end

      def initialize(graph, scope=nil)
        @nodes = graph.nodes
        @edges = graph.edges
        @scope = scope
      end

      def to_json
        to_hash.to_json
      end

    end

  end

end