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

    def self.from(content:, source_file:nil)
      parser = Analyst.for_source(content)
      containers = parser.top_level_entities.select{|e| e.respond_to? :all_methods}
      containers.map do |container|
        container.all_methods.map do |method|
          summary = Fukuzatsu::Summary.new(
            source: method.send(:contents),
            entity: container,
            source_file: source_file
          )
          binding.pry
          summary
        end
      end
    end

    def initialize(source:, entity:, source_file:nil)
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

    def entity_name
      self.entity.full_name
    end

    def to_s
      "#{self.source_file} #{self.entity_name} #{complexity}"
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