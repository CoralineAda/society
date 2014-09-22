class LineOfCode

  include PoroPlus
  include Ephemeral::Base

  attr_accessor :line_number, :range, :content

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
