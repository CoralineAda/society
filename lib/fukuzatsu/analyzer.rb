require 'parser/current'

class Analyzer

  INDICATORS = [:if, :def, :defs]

  attr_accessor :content, :edges, :nodes, :exits

  def self.parse!(content)
    new(content).parse!
  end

  def initialize(content)
    self.content = content
    self.edges = 0
    self.nodes = 1
    self.exits = 1
  end

  def complexity
    self.edges - self.nodes + exits
  end

  def extend_graph
    self.edges += 2
    self.nodes += 2
    self.exits += 1
  end

  def parent_node?(node)
    node.respond_to?(:type) || node.respond_to?(:children)
  end

  def parse!
    traverse(parsed) && complexity
  end

  def parsed
    Parser::CurrentRuby.parse(content)
  end

  def traverse(node, accumulator=[])
    accumulator << node.type
    extend_graph if INDICATORS.include?(node.type)
    node.children.each do |child|
      if parent_node?(child)
        accumulator << child.type
        traverse(child, accumulator)
      end
    end
    accumulator
  end


end

