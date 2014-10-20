module Formatters

  require 'terminal-table'
  require 'rainbow/ext/string'

  class Text

    include Formatters::Base

    def header
      ["Class/Module", "Method", "Complexity"]
    end

    def export
      return if rows.empty?
      table = Terminal::Table.new(
        title: file.path_to_file.color(:white),
        headings: header,
        rows: rows,
        style: {width: 90}
      )
      table.align_column(3, :right)
      puts table
    end

    def rows
      file.methods.map do |method|
        color = color_for(method)
        [wrap("#{file.class_name}").color(color), wrap("#{method.name}".color(color)), "#{method.complexity}".color(color)]
      end
    end

    def wrap(string)
      return string if string.length < 25
      string[0..24] << "..."
    end

  end

end

