module Fukuzatsu
  class ParsedMethod
    attr_reader :name, :complexity
    def initialize(name: name, complexity: complexity)
      @name = name
      @complexity = complexity
    end
  end
end
