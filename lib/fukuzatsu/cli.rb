require 'thor'
require 'fukuzatsu'

module Fukuzatsu

  class CLI < Thor

    desc_text = "Formats are text (default, to STDOUT), html, and csv. "
    desc_text << "Example: fuku check foo/ -f html"

    desc "check PATH_TO_FILE [-f FORMAT] [-t MAX_COMPLEXITY_ALLOWED]", desc_text
    method_option :format, :type => :string, :default => 'text', :aliases => "-f"
    method_option :threshold, :type => :numeric, :default => 0, :aliases => "-t"

    def check(path="./")

      file_summary = []
      file_complexities = []
      last_file = {}

      file_list(path).each do |path_to_file|
        file = ParsedFile.new(path_to_file: path_to_file)
        parser = formatter(options).new(file)
        parser.export
        file_summary << {
          results_file: "#{parser.output_path}/#{parser.filename}",
          path_to_file: path_to_file,
          class_name: "#{file.class_name}",
          complexity: file.complexity
        }
        file_complexities << file.complexity
      end

      last_file = handle_index(file_summary) if options['format'] == 'html'
      report(last_file[:results_file], file_summary.map{|s| s[:results_file]})
      handle_complexity(options, file_complexities.sort.last, options['threshold'])

    end

    default_task :check

    private

    def formatter(options)
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
      {results_file: "#{index.output_path}/#{index.filename}"}
    end

    def report(last_file, file_list)
     return if options['format'] == "text"
     puts "Results written to:"
     puts last_file.present? && "#{last_file}" || file_list.join("\r\n")
    end

    def handle_complexity(options, highest_complexity, threshold)
      return if options['threshold'].to_i == 0
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
