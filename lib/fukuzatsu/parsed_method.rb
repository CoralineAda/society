class ParsedMethod

  attr_reader :name, :content, :type, :complexity, :references

  def initialize(name: name, content: content, type: type, refs: refs=[], complexity: complexity)
    @name = name
    @content = content
    @type = type
    @references = refs
    @complexity = complexity
  end

  def complexity
    @complexity ||= analyzer.complexity
  end

  def name
    return "" if self.type == :none
    "#{prefix}#{@name}"
  end

  def prefix
    return "." if self.type == :class
    return "#" if self.type == :instance
    return "*"
  end

  def analyzer
    Analyzer.new(self.content)
  end

end