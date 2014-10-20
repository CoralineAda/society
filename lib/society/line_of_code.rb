class LineOfCode

  attr_reader :line_number, :range, :content

  def initialize(line_number: line_number, range: range, content: content)
    @line_number = line_number
    @range       = range
    @content     = content
  end

  def self.containing(locs, start_index, end_index)
    locs.inject([]) do |a, loc|
      a << loc if loc.in_range?(start_index) || loc.in_range?(end_index)
      a
    end.compact
  end

  def in_range?(index)
    self.range.include?(index)
  end

end