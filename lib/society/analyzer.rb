require 'parser/current'

class Analyzer

  CONDITIONALS = [:if, :or_asgn, :and_asgn, :or, :and]

  attr_accessor :content, :class_name, :edges, :nodes, :exits

  def initialize(content)
    self.content = content
  end

  def extract_class_name
    return self.class_name if self.class_name
    find_class(parsed) || "?"
  end

  private

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
    node.children.each do |child|
      if parent_node?(child)
        accumulator << child.type
        traverse(child, accumulator)
      end
    end
    accumulator
  end

end

