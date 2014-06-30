module Formatters

  class Csv

    def header
      columns.join(',')
    end

    private

    def columns
      ["class", "method", "complexity", "lines"]
    end

  end

end