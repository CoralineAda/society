require 'parser/current'

class Analyzer

  CONDITIONALS = [:if, :or_asgn, :and_asgn, :or, :and]

  attr_accessor :content, :class_name, :edges, :nodes, :exits

  def initialize(content)
    self.content = content
    self.edges = 0
    self.nodes = 1
    self.exits = 1
  end

  def complexity
    return unless traverse(parsed)
    self.edges - self.nodes + exits
  end

  def extract_methods
    @methods ||= methods_from(parsed)
  end

  def extract_class_name
    return self.class_name if self.class_name
    name = parsed.children.select{|node| node.type == :class}.first.loc.name
    self.class_name = self.content[name.begin_pos..(name.end_pos - 1)]
  end

  private

  def extend_graph
    self.edges += 2
    self.nodes += 2
    self.exits += 1
  end

  def methods_from(node, methods=[])
    if node.type == :def || node.type == :defs
      name = node.loc.name
      expression = node.loc.expression
      methods << ParsedMethod.new(
        name: content[name.begin_pos..name.end_pos - 1],
        content: content[expression.begin_pos..expression.end_pos - 1],
        type: node.type == :defs ? :class : :instance
      )
    end
    node.children.each do |child|
      if parent_node?(child)
        methods_from(child, methods)
      end
    end
    methods
  end

  def parent_node?(node)
    node.respond_to?(:type) || node.respond_to?(:children)
  end

  def parse!
    traverse(parsed) && complexity
  end

  def parsed
    @parsed ||= Parser::CurrentRuby.parse(content)
  end

  def traverse(node, accumulator=[], extract_methods=false)
    accumulator << node.type
    extend_graph if CONDITIONALS.include?(node.type)
    node.children.each do |child|
      if parent_node?(child)
        accumulator << child.type
        traverse(child, accumulator)
      end
    end
    accumulator
  end

end

