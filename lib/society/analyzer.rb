require 'parser/current'
require 'pry'

module Society

  class Analyzer

    attr_reader :content

    DEFAULT_CLASS_NAME = "Unknown"

    def initialize(content)
      @content = content
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

    private

    def method_list
      @method_list ||= method_names_from(parsed.children.first)
    end

    def method_names_from(node, found=[])
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
      found
    end

    def find_class(node)
      return unless node && node.respond_to?(:type)
      concat = []
      if node.type == :module || node.type == :class
        concat << text_at(node.loc.name.begin_pos, node.loc.name.end_pos)
      end
      concat << node.children.map{|child| find_class(child)}.compact
      concat.flatten.reject(&:empty?).join('::')
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

    def methods_from(node, found=[])
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
        found << ParsedMethod.new(
          name: content[name.begin_pos..name.end_pos - 1],
          content: content[expression.begin_pos..expression.end_pos - 1],
          type: type,
          refs: extract_references_from(node)
        )
      end
      node.children.each do |child|
        if parent_node?(child)
          methods_from(child, found)
        end
      end
      found
    end

    def parent_node?(node)
      node.respond_to?(:type) || node.respond_to?(:children)
    end

    def parse!
      traverse(parsed) && complexity
    end

    def parsed
      @parsed ||= ::Parser::CurrentRuby.parse(content)
    end

    def text_at(start_pos, end_pos)
      content[start_pos..end_pos - 1]
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

end
