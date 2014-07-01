require 'parser/current'

class ParsedMethod

  include PoroPlus

  attr_accessor :name, :content, :type

  def complexity
    @complexity ||= Analyzer.parse!(content)
  end

  def prefix
    self.type == :class ? "." : "#"
  end

end