require 'thor'
require 'fukuzatsu'

module Fukuzatsu

  class CLI < Thor

    desc "parse PATH_TO_FILE", "Parse a file."
    def parse(file)
      file = ParsedFile.new(path_to_file: file)

      puts "#{file.class_name}\t\t#{file.complexity}"
      file.methods.each do |method|
        puts "#{file.class_name}\t#{method.prefix}#{method.name}\t#{method.complexity}"
      end

    end

  end

end