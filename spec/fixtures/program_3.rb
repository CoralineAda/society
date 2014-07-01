require 'parser/current'

class Analyzer

  INDICATORS = [
    :if,
    :def,
  ]

  attr_accessor :path_to_file, :edges, :nodes, :exits, :accumulator

  def self.parse!(path_to_file)
    new(path_to_file).parse
  end

  def initialize(path_to_file)
    self.accumulator = []
    self.edges = 0
    self.nodes = 1
    self.exits = 1
    self.path_to_file = path_to_file
  end

  def file_contents
    File.open(path_to_file, "r").read
  end

  def parsed
    @parsed ||= Parser::CurrentRuby.parse(file_contents)
  end

  def parse!
    traverse(parsed)
    complexity
  end

  def traverse(node)#, accumulator=[])

    accumulator << node.type

    if node.type == :if || node.type == :begin
      self.edges += 2
      self.nodes += 2
      self.exits += 1
    elsif node.type == :def
      self.edges += 1
      self.nodes += 1
      self.exits += 1
    end

    node.children.each do |child|
      if child.respond_to?(:type) || child.respond_to?(:children)
        accumulator << child.type
        traverse(child, accumulator)
      else
      end
    end
  end

  def complexity
    p "edges = #{self.edges}, nodes = #{self.nodes}, exits = #{self.exits}"
    self.edges - self.nodes + exits
  end

end

