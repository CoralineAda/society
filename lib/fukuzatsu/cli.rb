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
        parser = formatter.new(file)
        parser.export
        file_summary << {
          results_file: "#{parser.output_path}/#{parser.filename}",
          path_to_file: path_to_file,
          class_name: "#{file.class_name}",
          complexity: file.complexity
        }
        file_complexities << file.complexity
        last_file = file_summary.last
      end

      last_file = handle_index(file_summary) if options['format'] == 'html'
      report(last_file[:results_file])
      handle_complexity(file_complexities.sort.last, options['threshold'])

    end

    private

    def formatter
      formatter = case options['format']
      when 'html'
        Formatters::Html
      when 'csv'
        Formatters::Csv
      else
        Formatters::Text
      end
    end

    def handle_index(file_summary)
      index = Formatters::HtmlIndex.new(file_summary)
      index.export
      {results_file: index.output_path}
    end

    def report(last_file)
     puts "Results written to:"
     puts "\t#{last_file}"
    end

    def handle_complexity(max, threshold)
      return if options['threshold'] == 0
      return if highest_complexity <= options['threshold']
      puts "Maximum complexity is #{highest_complexity}, which is greater than the threshold of #{options['threshold']}."
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