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

      file_summary = []
      file_complexities = []

      file_list(path).each do |path_to_file|
        file = ParsedFile.new(path_to_file: path_to_file)
        case options['format']
        when 'html'
          Formatters::Html.new(file).export
        when 'csv'
          Formatters::Csv.new(file).export
        else
          Formatters::Text.new(file).export
        end
        file_summary << {path_to_file: path_to_file, class_name: "#{file.class_name}", complexity: file.complexity}
        file_complexities << file.complexity
      end

      Formatters::HtmlIndex.new(file_summary).export if options['format'] == 'html'

      handle_complexity(file_complexities.sort.last, options['threshold'])

    end

    private

    def write_index(file_list)
      Formatters::Html.write_index(file_list)
    end

    def handle_complexity(max, threshold)
      return if options['threshold'] == 0
      return if highest_complexity <= options['threshold']
      puts "=" * 40
      puts "Maximum complexity is #{highest_complexity}, which is greater than the threshold of #{options['threshold']}."
      puts "=" * 40
      exit 1
    end

    def file_list(start_file)
      if File.directory?(start_file)
        return Dir.glob(File.join(start_file, "**", "*")).select{|n| n =~ /\.rb$/}
      else
        return [start_file]
      end
    end

  end

end