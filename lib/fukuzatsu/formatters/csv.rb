module Formatters

  class Csv

    include Formatters::Base

    def header
      columns.join(',')
    end

    def rows
      file.methods.inject([]) do |a, method|
        a << "#{file.class_name},#{method.prefix}#{method.name},#{method.complexity}"
        a
      end.join("\r\n")
    end

    def footer
    end

    def file_extension
      ".csv"
    end

  end

end