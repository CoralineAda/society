module Formatters

  class Html

    include Formatters::Base

    def header
      columns.map{|col| "<th>#{col}</th>"}.join("\r\n")
    end

    def content
      Haml::Engine.new(template).render(Object.new, {header: header, rows: rows})
    end

    def template
      File.read(File.dirname(__FILE__) + "/templates/output.html.haml")
    end

    def rows
      parsed_files.inject([]) do |a, parsed_file|
        parsed_file.parsed_methods.each do |method|
          a << "<tr>"
          a << [
            parsed_file.class_name,
            method.method_name,
            method.complexity,
            method.loc
          ].map{|column| "<td>#{column}</td>"}
        end
        a << "</tr>"
        a
      end.join("\r\n")
    end

    def footer
    end

  end

end