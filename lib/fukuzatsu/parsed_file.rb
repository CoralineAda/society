class ParsedFile

  include PoroPlus
  include Ephemeral::Base

  attr_accessor :complexity, :path_to_file, :class_name, :path_to_results

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

  def summary
    {
      results_file: self.path_to_results,
      path_to_file: self.path_to_file,
      class_name: self.class_name,
      complexity: complexity
    }
  end

end