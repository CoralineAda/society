module Formatters

  class Csv

    include PoroPlus
    include Ephemeral::Base
    collects :parsed_files

    def initialize(files=[])
      self.parsed_files = files
    end

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

    private

    def columns
      ["class", "method", "complexity", "lines"]
    end

  end

end