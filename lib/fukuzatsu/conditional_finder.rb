module Fukuzatsu

  class ConditionalFinder

    attr_reader :ast

    def initialize(ast)
      @ast = ast
    end

    def conditionals
      extract_conditionals(self.ast)
    end

    def extract_conditionals(ast, carry=[])
      return carry unless ast && ast.respond_to?(:children)
      carry << ast.children.map do |child|
        extract_conditionals(child, carry)
      end
    end

  end

end