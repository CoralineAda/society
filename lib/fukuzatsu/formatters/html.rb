module Formatters

  class Html

    include Formatters::Base

    def header
      columns.join(',')
    end

    def rows
      parsed_files.inject([]) do |a, parsed_file|
        parsed_file.parsed_methods.each do |method|
          a << [
            parsed_file.class_name,
            method.method_name,
            method.complexity,
            method.loc
          ].join(",")
        end
        a
      end
    end

    def footer
    end

  end

end