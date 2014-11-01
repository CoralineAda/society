module Fukuzatsu

  class Summary

    attr_reader :entity, :source, :source_file
    attr_accessor :edges, :nodes, :exits

    BRANCHES = [
      :if,
      :or_asgn,
      :and_sgn,
      :or,
      :and
    ]

    def self.from(content: content, source_file: source_file=nil)
      parser = Analyst::Parser.from_source(content)
      entities = parser.classes
      entities << parser.modules
      entities = entities.reject{ |entity| entity.blank? }
      entities = entities.flatten.uniq
      entities.map do |entity|
        summary = Summary.new(
          source: content,
          entity: entity,
          source_file: source_file
        )
      end
    end

    def initialize(source: source, entity: entity, source_file: source_file=nil)
      @source = source
      @entity = entity
      @source_file = source_file
      @edges, @nodes, @exits = [0, 1, 1]
    end

    def complexity
      @complexity ||= begin
        traverse(self.entity.ast)
        self.edges - self.nodes + self.exits
      end
    end

    def to_s
      "#{self.source_file} #{self.entity.full_name} #{complexity}"
    end

    private

    def extend_graph
      self.edges += 2
      self.nodes += 2
      self.exits += 1
    end

    def traverse(node, accumulator=[])
      accumulator << node.type
      extend_graph if BRANCHES.include?(node.type)
      node.children.each do |child|
        if child.respond_to?(:children) || child.respond_to?(:type)
          accumulator << child.type
          traverse(child, accumulator)
        end
      end
      accumulator
    end
  end

end