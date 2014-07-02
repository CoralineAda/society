require 'thor'
require 'fukuzatsu'

module Fukuzatsu

  class CLI < Thor

    desc "parse PATH_TO_FILE -f FORMAT", "Formats are text (default, to STDOUT), html, and csv. Ex: parse foo.rb -f html"
    method_option :format, :type => :string, :default => 'text', :aliases => "-f"
    def parse(file)

      if File.directory?(file)
        file_list = Dir.glob(File.join(file, "**", "*")).select{|n| n =~ /\.rb$/}
      else
        file_list = [file]
      end

      file_list.each do |file|
        file = ParsedFile.new(path_to_file: file)
        case options['format']
        when 'html'
          Formatters::Html.new(file).export
        when 'csv'
          Formatters::Csv.new(file).export
        else
          Formatters::Text.new(file).export
        end
      end

    end

  end

end