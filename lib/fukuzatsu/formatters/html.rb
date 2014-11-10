require 'rouge'

module Fukuzatsu

  module Formatters

    class Html

      include Formatters::Base

      def self.explain(count)
        puts "Processed #{count} file(s). Results written to #{new.output_directory}."
      end

      def self.has_index?
        false
      end

      def self.index(summaries)
        Fukuzatsu::Formatters::HtmlIndex.new(summaries).export
      end

      def self.index_class
        Formatters::HtmlIndex
      end

      def self.writes_to_file_system?
        true
      end

      def columns
        ["class", "method", "complexity"]
      end

      def content
        Haml::Engine.new(output_template).render(
          Object.new, {
            header: header,
            rows: rows,
            source_lines: preprocessed,
            class_name: summary.container_name,
            complexity: summary.complexity,
            path_to_file: summary.source_file,
            date: Time.now.strftime("%Y/%m/%d"),
            time: Time.now.strftime("%l:%M %P")
          }
        )
      end

      def export
        begin
          File.open(path_to_results, 'w') {|outfile| outfile.write(content)}
        rescue Exception => e
          puts "Unable to write output: #{e} #{e.backtrace}"
        end
      end

      def file_extension
        ".htm"
      end

      def formatter
        Rouge::Formatters::HTML.new(line_numbers: true)
      end

      def header
        columns.map{|col| "<th>#{col.titleize}</th>"}.join("\r\n")
      end

      def lexer
        lexer = Rouge::Lexers::Ruby.new
      end

      def output_template
        File.read(File.dirname(__FILE__) + "/templates/output.html.haml")
      end

      def preprocessed
        formatter.format(lexer.lex(summary.raw_source))
      end

      def rows
        i = 0
        summary.summaries.inject([]) do |a, summary|
          i += 1
          a << "<tr class='#{i % 2 == 1 ? 'even' : 'odd'}'>"
          a << "  <td>#{summary.container_name}</td>"
          a << "  <td>#{summary.entity_name}</td>"
          a << "  <td>#{summary.complexity}</td>"
          a << "</tr>"
          a
        end.join("\r\n")
      end

    end

  end
end