module Formatters

  class Csv

    include Formatters::Base

    def header
    end

    def rows
      file.methods.inject([]) do |a, method|
        a << "#{file.path_to_file},#{file.class_name},#{method.prefix}#{method.name},#{method.complexity}"
        a
      end.join("\r\n")
    end

    def footer
    end

    def path_to_results
      File.join(root_path, "results#{file_extension}")
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