require 'thor'
require 'fukuzatsu'

module Fukuzatsu

  class CLI < Thor

    desc "parse PATH_TO_FILE", "Parse a file."
    def parse(file)
      puts "Parsing #{file}..."
      file = ParsedFile.new(path_to_file: file)
      puts "Overall complexity: #{file.complexity}"
    end

  end

end