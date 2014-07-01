require 'thor'
require 'fukuzatsu'

module Fukuzatsu

  class CLI < Thor

    desc "parse PATH_TO_FILE --format", "Parse a file."
    def parse(file, format='text')
      file = ParsedFile.new(path_to_file: file)
      case format
      when 'html'
        puts Formatters::Html.new(file).content
      when 'csv'
        puts Formatters::Csv.new(file).content
      else
        puts Formatters::Text.new(file).content
      end
    end

  end

end