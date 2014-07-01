module Formatters

  module Base

    def self.included(klass)
      klass.send(:attr_accessor, :file)
    end

    def initialize(file)
      self.file = file
    end

    def content
      [header, rows, footer].flatten.join("\r\n")
    end

    def columns
      ["class", "method", "complexity", "lines"]
    end

    def output_path
      output_path = "docs/fukuzatsu/#{self.file.file_to_path.split('/')[0..-2]}"
      top_level = FileUtils.mkpath(output_path)
      output_path
    end

    def filename
      self.file.file_to_path.split('/')[-1] + file_extension
    end

    def write
      begin
        outfile = File.open("#{output_path}/#{filename}", 'w')
        outfile.write(content)
      rescue Exception => e
        puts "Unable to write output: #{e} #{e.backtrace}"
      ensure
        outfile.close
      end
    end

  end

end
