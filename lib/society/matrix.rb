require 'json'
require 'pry'

module Society

  class Matrix

    attr_reader :nodes

    def initialize(nodes)
      @nodes = nodes
    end

    def to_hash
      {
        nodes: node_names.map{ |name| {name: name, group: 1} },
        links: self.nodes.map do |node|
          node.edges.map do |edge|
            next if node_name_symbols.index(edge).nil? # Fix this namespacing hack
            {source: node_names.index(node.name), target: node_name_symbols.index(edge), value: 1}
          end
        end.flatten.compact
      }
    end

    def to_json
      to_hash.to_json
    end

    private

    def node_names
      self.nodes.map(&:name)
    end

    def node_name_symbols
      node_names.map{ |name| name.gsub(/^./, '').to_sym }
    end

  end

end