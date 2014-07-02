module Formatters

  class Html

    include Formatters::Base

    def header
      columns.map{|col| "<th>#{col.titleize}</th>"}.join("\r\n")
    end

    def content
      Haml::Engine.new(template).render(Object.new, {
          header: header,
          rows: rows,
          class_name: file.class_name,
          path_to_file: file.path_to_file,
          date: Time.now.strftime("%Y/%m/%d"),
          time: Time.now.strftime("%l:%M %P")
        }
      )
    end

    def template
      File.read(File.dirname(__FILE__) + "/templates/output.html.haml")
    end

    def rows
      i = 0
      file.methods.inject([]) do |a, method|
        i += 1
        a << "<tr class='#{i % 2 == 1 ? 'even' : 'odd'}'>"
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