module Formatters

  module Base

    def self.included(klass)
      klass.send(:include, PoroPlus)
      klass.send(:include, Ephemeral::Base)
      klass.send(:collects, :parsed_files)
    end

    def initialize(files=[])
      self.parsed_files = files
    end

    def columns
      ["class", "method", "complexity", "lines"]
    end

    def output_path
      top_level = File.dirname("docs")
      bot_level = File.dirname("docs/fukuzatsu")
      FileUtils.mkdir_p(top_level) unless File.directory?(top_level)
      FileUtils.mkdir_p(bot_level) unless File.directory?(bot_level)
      "docs/fukuzatsu"
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
