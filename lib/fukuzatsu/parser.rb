module Fukuzatsu

  class Parser

    attr_reader :file_list, :summaries, :last_file
    attr_accessor :threshold

    def initialize(path)
      @file_list = file_list(path)
    end

    def parse_files
      self.file_list(path).each{ |path_to_file| parse(path_to_file) }
      handle_index(summaries)
      report
    end

    private

    def complexities
      self.summaries.to_a.map{|s| s[:complexity]}
    end

    def file_list(start_file)
      if File.directory?(start_file)
        return Dir.glob(File.join(start_file, "**", "*.rb"))
      else
        return [start_file]
      end
    end

    def formatter
      case options['format']
      when 'html'
        Formatters::Html
      when 'csv'
        Formatters::Csv
      else
        Formatters::Text
      end
    end

    def handle_index(file_summary)
      return unless options['format'] == 'html'
      index = Formatters::HtmlIndex.new(file_summary)
      self.last_file = File.join(index.output_path, index.filename)
      index.export
    end

    def parse(path_to_file, options={})
      file = ParsedFile.new(path_to_file: path_to_file)
      parser = formatter.new(file, file.source)
      parser.export
      @summaries ||= []
      @summaries << file.summary.merge(results_file: parser.path_to_results)
      last_file = file
    end

    def report
      puts "Results written to #{formatter.root_path} "
      report_complexity
    end

    def report_complexity
      return if options['threshold'].to_i == 0
      return if complexities.max.to_i <= options['threshold']
      puts "Maximum complexity of #{complexities.max} exceeds #{options['threshold']} threshold!"
      exit 1
    end

    def results_files
      summaries.map{|s| s[:results_file]}
    end

  end

  end

end