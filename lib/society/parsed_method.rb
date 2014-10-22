module Society

  class ParsedMethod

    attr_reader :name, :content, :type, :references

    def initialize(name: name, content: content, type: type, refs: refs=[])
      @name = name
      @content = content
      @type = type
      @references = refs
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

end
