class ParsedMethod

  attr_reader :name, :content, :type

  def initialize(name: name, content: content, type: type)
    @name = name
    @content = content
    @type = type
  end

  def name
    return "" if self.type == :none
    "#{prefix}#{@name}"
  end

  private

  def prefix
    return "." if self.type == :class
    return "#" if self.type == :instance
    return "*"
  end

end