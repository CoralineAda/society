module Formatters

  module Base

    def self.included(klass)
      klass.send(:attr_accessor, :file)
      klass.send(:attr_accessor, :source)
    end

    def initialize(file, source="")
      self.file = file
      self.source = source
    end

    def content
      [header, rows, footer].flatten.join("\r\n")
    end

    def columns
      ["class", "method", "complexity"]
    end

    def root_path
      "doc/fukuzatsu"
    end

    def output_path
      output_path = File.dirname(File.join(root_path, self.file.path_to_file))
      FileUtils.mkpath(output_path)
      output_path
    end

    def path_to_results
      File.join(output_path, filename)
    end

    def filename
      File.basename(self.file.path_to_file) + file_extension
    end

    def file_extension
      ""
    end

    def export
      begin
        File.open(path_to_results, 'w') {|outfile| outfile.write(content)}
      rescue Exception => e
        puts "Unable to write output: #{e} #{e.backtrace}"
      end
    end

  end

end
