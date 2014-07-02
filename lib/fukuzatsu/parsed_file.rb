class ParsedFile

  include PoroPlus
  include Ephemeral::Base

  attr_accessor :path_to_file, :class_name

  def class_name
    @class_name ||= analyzer.extract_class_name
  end

  def content
    @content ||= File.open(path_to_file, "r").read
  end

  def analyzer
    Analyzer.new(content)
  end

  def complexity
    @complexity ||= analyzer.complexity
  end

  def methods
    @methods ||= analyzer.extract_methods
  end

end