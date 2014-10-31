class ParsedFile

  attr_accessor :lines_of_code, :source
  attr_accessor :complexity, :path_to_file, :class_name, :path_to_results

  def initialize(path_to_file: path_to_file, class_name: class_name=nil, complexity: complexity)
    @path_to_file = path_to_file
    @class_name = class_name
    @lines_of_code = []
    @complexity = complexity
    @source = parse!
  end

  def parsed_content
    @parsed_content ||= Analyst.new(self.path_to_file)
  end

  def class_name
    @class_name ||= parsed_content.classes.first.full_name
  end

  def class_references
    @class_references ||= parsed_content.constants
  end

  def content
    @content ||= File.open(path_to_file, "r").read
  end

  def average_complexity
    methods.map(&:complexity).reduce(:+) / methods.count.to_f
  end

  def complexity
    @complexity ||= analyzer.complexity
  end

  def methods
    @methods ||= parsed_content.classes.first.all_methods.map(&:name)
  end

  def method_counts
    referenced_methods = methods.map(&:references).flatten
    referenced_methods.inject({}) do |hash, method|
      hash[method] ||= 0
      hash[method] += 1
      hash
    end
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
      path_to_file: self.path_to_file,
      results_file: self.path_to_results,
      source: source,
      class_name: self.class_name,
      complexity: complexity
    }
  end

  private

  def analyzer
    @analyzer ||= Analyzer.new(content)
  end

  def content
    @content ||= File.open(path_to_file, "r").read
  end

  def parse!
    end_pos = 0
    File.readlines(self.path_to_file).each_with_index do |line, index|
      start_pos = end_pos + 1
      end_pos += line.size
      self.lines_of_code << LineOfCode.new(line_number: index + 1, range: (start_pos..end_pos))
      line
    end.join
  end

end
