class ParsedFile

  include Ephemeral::Base
  collects :parsed_methods

  attr_accessor :path_to_file, :class_name

  def initialize(path_to_file)
    self.path_to_file = path_to_file
  end

  def content
    File.open(path_to_file, "r").read
  end

  def complexity
    @complexity ||= Analyzer.parse!(content)
  end

end