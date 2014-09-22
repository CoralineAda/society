class ParsedFile

  include PoroPlus
  include Ephemeral::Base

  attr_accessor :complexity, :path_to_file, :class_name, :path_to_results
  attr_accessor :lines_of_code, :source

  def class_name
    @class_name ||= analyzer.extract_class_name
  end

  def content
    @content ||= File.open(path_to_file, "r").read
  end

  def analyzer
    @analyzer ||= Analyzer.new(content)
  end

  def complexity
    @complexity ||= analyzer.complexity
  end

  def methods
    @methods ||= analyzer.extract_methods
  end

  def source
    return @source if @source
    end_pos = 0
    self.lines_of_code = []
    @source = File.readlines(self.path_to_file).each_with_index do |line, index|
      start_pos = end_pos + 1
      end_pos += line.size
      self.lines_of_code << LineOfCode.new(line_number: index + 1, range: (start_pos..end_pos))
      line
    end.join
  end

  def summary
    {
      results_file: self.path_to_results,
      path_to_file: self.path_to_file,
      source: source,
      class_name: self.class_name,
      complexity: complexity
    }
  end

end