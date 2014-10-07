class ParsedMethod

  include PoroPlus

  attr_accessor :name, :content, :type, :complexity

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