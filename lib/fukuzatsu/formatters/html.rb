require 'rouge'

module Formatters

  class Html

    include Formatters::Base

    def self.has_index?
      true
    end

    def self.writes_to_file_system?
      true
    end

    def self.index_class
      Formatters::HtmlIndex
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
          class_name: file.class_name,
          complexity: file.complexity,
          path_to_file: file.path_to_file,
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
      formatter.format(lexer.lex(source))
    end

    def rows
      i = 0
      file.methods.inject([]) do |a, method|
        i += 1
        a << "<tr class='#{i % 2 == 1 ? 'even' : 'odd'}'>"
        a << "  <td>#{file.class_name}</td>"
        a << "  <td>#{method.name}</td>"
        a << "  <td>#{method.complexity}</td>"
        a << "</tr>"
        a
      end.join("\r\n")
    end

    def file_extension
      ".htm"
    end

  end

end
