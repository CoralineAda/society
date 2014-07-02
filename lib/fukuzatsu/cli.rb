require 'thor'
require 'fukuzatsu'

module Fukuzatsu

  class CLI < Thor

    desc_text = "Formats are text (default, to STDOUT), html, and csv. "
    desc_text << "Example: fuku check foo/ -f html"

    desc "check PATH_TO_FILE [-f FORMAT] [-t MAX_COMPLEXITY_ALLOWED]", desc_text
    method_option :format, :type => :string, :default => 'text', :aliases => "-f"
    method_option :threshold, :type => :numeric, :default => 0, :aliases => "-t"

    def check(path)

      file_complexities = file_list(path).map do |file|
        file = ParsedFile.new(path_to_file: file)
        case options['format']
        when 'html'
          Formatters::Html.new(file).export
        when 'csv'
          Formatters::Csv.new(file).export
        else
          Formatters::Text.new(file).export
        end
        file.complexity
      end

      highest_complexity = file_complexities.sort.last

      if options['threshold'] != 0 && highest_complexity > options['threshold']
        puts "Maximum complexity is #{highest_complexity}, which is greater than the threshold of #{options['threshold']}."
        exit 1
      end

    end

    private

    def file_list(start_file)
      if File.directory?(start_file)
        return Dir.glob(File.join(start_file, "**", "*")).select{|n| n =~ /\.rb$/}
      else
        return [start_file]
      end
    end

  end

end