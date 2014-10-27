require 'json'
require 'pry'

module Society

  module Matrix

    module Core

      def self.included(klass)
        klass.send(:attr_reader, :nodes)
      end

      def initialize(nodes)
        @nodes = nodes
      end

      def to_json
        to_hash.to_json
      end

      def node_names
        self.nodes.map(&:name)
      end

      def node_name_symbols
        node_names.map{ |name| name.gsub(/^./, '').to_sym }
      end

    end

  end

end