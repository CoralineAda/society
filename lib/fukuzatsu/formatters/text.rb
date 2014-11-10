module Fukuzatsu

  module Formatters

    require 'terminal-table'
    require 'rainbow/ext/string'

    class Text

      include Formatters::Base

      def self.has_index?
        false
      end

      def self.writes_to_file_system?
        false
      end

      def color_for(entity, average_complexity)
        return :green if entity.complexity == 0
        return :yellow if entity.complexity <= average_complexity
        return :red if entity.complexity > average_complexity
        return :white
      end

      def header
        ["Class/Module", "Method", "Complexity"]
      end

      def export
        table = Terminal::Table.new(
          title: "#{summary.source_file}".color(:white),
          headings: header,
          rows: rows,
          style: {width: 120}
        )
        table.align_column(3, :right)
        puts table
      end

      def rows
        rows_for(
          [self.summary, self.summary.summaries].flatten,
          self.summary.average_complexity
        )
      end

      def rows_for(summaries, average_complexity)
        summaries.map do |summary|
          color = color_for(summary, average_complexity)
          [
            wrap("#{summary.container_name}").color(color),
            wrap("#{summary.entity_name}".color(color)),
            "#{summary.complexity}".color(color)
          ]
        end.compact
      end

      def wrap(string)
        return string if string.length < 50
        string[0..49] << "..."
      end

    end

  end
end
