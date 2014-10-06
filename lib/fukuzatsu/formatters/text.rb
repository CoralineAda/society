module Formatters

  class Text

    include Formatters::Base

    def self.has_index?
      false
    end

    def header
      "#{file.class_name}\t\t#{file.complexity}"
    end

    def export
      puts content
    end

    def format
      'text'
    end

    def rows
      file.methods.map do |method|
        "#{file.class_name}\t#{method.prefix}#{method.name}\t#{method.complexity}"
      end
    end

    def footer
    end

  end

end

