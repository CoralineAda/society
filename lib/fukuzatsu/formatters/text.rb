module Formatters

  class Text

    include Formatters::Base

    def header
      "#{file.class_name}\t\t#{file.complexity}"
    end

    def rows
      file.methods.map do |method|
        "#{file.class_name}\t#{method.prefix}#{method.name}\t#{method.complexity}"
      end
    end

  end

end

