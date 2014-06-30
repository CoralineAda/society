require 'thor'
require 'fukuzatsu'

module Fukuzatsu

  class CLI < Thor

    desc "parse PATH_TO_FILE", "Parse a file."
    def parse(file)
      puts "Parsing #{file}..."
      puts Parser.parse!(file)
    end

  end

end