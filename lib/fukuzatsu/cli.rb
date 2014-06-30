require 'thor'
require 'fukuzatsu'

module Fukuzatsu

  class CLI < Thor

    desc "parse PATH_TO_FILE", "Parse a file."
    def parse(file)
      puts "Parsing #{file}..."
      puts Fukuzatsu::Parser.parse!(file).output
    end

  end

end