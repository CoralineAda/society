require 'parser/current'

class Analyzer

  CONDITIONALS = [:if, :or_asgn, :and_asgn, :or, :and]

  attr_accessor :content, :class_name, :edges, :nodes, :exits

  DEFAULT_CLASS_NAME = "Unknown"

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

  def class_name
    find_class(parsed) || DEFAULT_CLASS_NAME
  end

  def methods
    @methods ||= methods_from(parsed)
  end

  def constants
    @constants ||= constants_from(parsed)
  end

  def method_names
    @method_names ||= method_names_from(parsed)
  end

  def extract_methods
    @methods ||= methods_from(parsed)
  end

  def extract_class_name
    return self.class_name if self.class_name && ! self.class_name.empty?
    found = find_class(parsed)
    self.class_name = ! found.empty? && found || DEFAULT_CLASS_NAME
  end

  private

  def method_list
    @method_list ||= method_names
  end

  def method_names_from(node, found=[])
    return found unless node.respond_to?(:type)
    if node.type == :def || node.type == :defs
      name = node.loc.name
      found << content[name.begin_pos..name.end_pos - 1].to_sym
    end
    node.children.each do |child|
      method_names_from(child, found) if parent_node?(child)
    end
    found
  end

  def constants_from(node, found=[])
    if node.type == :const
      expression = node.loc.expression
      found << content[expression.begin_pos..expression.end_pos - 1]
    end
    node.children.each do |child|
      constants_from(child, found) if parent_node?(child)
    end
    found.reject{ |constant| constant == class_name }
  end

  def extract_references_from(node, found=[])
    return found unless node && node.respond_to?(:type)
    if node.type == :send
      reference = node.loc.expression
      found << node.children.last
    end
    node.children.each do |child|
      extract_references_from(child, found)
    end
    found.select{|name| method_list.include?(name)}
  end

  def text_at(start_pos, end_pos)
    content[start_pos..end_pos - 1]
  end

  def find_class(node)
    return unless node && node.respond_to?(:type)
    concat = []
    if node.type == :module || node.type == :class
      concat << text_at(node.loc.name.begin_pos, node.loc.name.end_pos)
    end
    concat << node.children.map{|child| find_class(child)}.compact
    concat.flatten.select(&:present?).join('::')
  end

  def extend_graph
    self.edges += 2
    self.nodes += 2
    self.exits += 1
  end

  def methods_from(node, methods=[])
    if node.type == :def || node.type == :defs
      name = node.loc.name
      expression = node.loc.expression
      type = case(node.type)
        when :defs
          :class
        when :def
          :instance
        when :class
          :none
      end
      methods << ParsedMethod.new(
        name: content[name.begin_pos..name.end_pos - 1],
        content: content[expression.begin_pos..expression.end_pos - 1],
        type: type,
        refs: extract_references_from(node)
      )
    end
    node.children.each do |child|
      if parent_node?(child)
        methods_from(child, methods)
      end
    end
    methods.reject{ |m| m.name.empty? }
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

