module Formatters

  class Html

    include Formatters::Base

    # def self.write_index(file_list)
    #   index_template = File.read(File.dirname(__FILE__) + "/templates/index.html.haml")
    #   Haml::Engine.new(index_template).render(
    #     Object.new, {
    #       file_list: file_list,
    #       date: Time.now.strftime("%Y/%m/%d"),
    #       time: Time.now.strftime("%l:%M %P")
    #     }
    #   )
    # end

    def header
      columns.map{|col| "<th>#{col.titleize}</th>"}.join("\r\n")
    end

    def content
      Haml::Engine.new(output_template).render(
        Object.new, {
          header: header,
          rows: rows,
          class_name: file.class_name,
          complexity: file.complexity,
          path_to_file: file.path_to_file,
          date: Time.now.strftime("%Y/%m/%d"),
          time: Time.now.strftime("%l:%M %P")
        }
      )
    end

    def output_template
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
