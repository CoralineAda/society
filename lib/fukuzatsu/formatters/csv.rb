module Formatters

  class Csv

    include Formatters::Base

    def self.has_index?
      false
    end

    def content
      rows + "\r\n"
    end

    def rows
      file.methods.map do |method|
        "#{file.path_to_file},#{file.class_name},#{method.prefix}#{method.name},#{method.complexity}"
      end.join("\r\n")
    end

    def footer
    end

    def path_to_results
      File.join(output_directory, "results#{file_extension}")
    end

    def file_extension
      ".csv"
    end

    def export
      begin
        File.open(path_to_results, 'a') {|outfile| outfile.write(content)}
      rescue Exception => e
        puts "Unable to write output: #{e} #{e.backtrace}"
      end
    end

  end

end