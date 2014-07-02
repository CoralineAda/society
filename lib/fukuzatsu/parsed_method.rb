require 'parser/current'

class ParsedMethod

  include PoroPlus

  attr_accessor :name, :content, :type

  def complexity
    @complexity ||= Analyzer.new(content).complexity
  end

  def prefix
    self.type == :class ? "." : "#"
  end

end