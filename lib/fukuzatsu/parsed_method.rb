class ParsedMethod

  include PoroPlus

  attr_accessor :name, :content, :type, :complexity

  def complexity
    @complexity ||= analyzer.complexity
  end

  def prefix
    self.type.to_s == 'class' ? "." : "#"
  end

  def analyzer
    Analyzer.new(self.content)
  end

end