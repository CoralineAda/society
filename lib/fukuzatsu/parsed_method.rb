require 'parser/current'

class ParsedMethod

  include PoroPlus

  attr_accessor :name, :content

  def complexity
    @complexity ||= Analyzer.parse!(content)
  end

end