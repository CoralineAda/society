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
      file.methods.inject([]) do |a, method|
        a << "<tr>"
        a << "  <td>#{file.class_name}</td>"
        a << "  <td>#{method.prefix}#{method.name}</td>"
        a << "  <td>#{method.complexity}</td>"
        a << "</tr>"
        a
      end.join("\r\n")
    end

    def footer
    end

    def file_extension
      ".htm"
    end


  end

end