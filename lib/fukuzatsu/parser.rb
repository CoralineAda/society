require 'fileutils'

module Fukuzatsu

  class Parser

    attr_reader :start_path, :summaries, :last_file, :start_file, :last_file, :format, :threshold

    def initialize(path, format, threshold=nil)
      @start_path = path
      @format = format
      @threshold = threshold
    end

    def parse_files
      init_directory
      file_list.each{ |path_to_file| parse(path_to_file) }
      handle_index(summaries)
      report
    end

    private

    def init_directory
      begin
        FileUtils.remove_dir(root_path)
      rescue
      ensure
        FileUtils.mkpath(root_path)
      end
    end

    def complexities
      self.summaries.to_a.map{|s| s[:complexity]}
    end

    def file_list
      if File.directory?(start_path)
        return Dir.glob(File.join(start_path, "**", "*.rb"))
      else
        return [start_path]
      end
    end

    def formatter
      case format
      when 'html'
        Formatters::Html
      when 'csv'
        Formatters::Csv
      else
        Formatters::Text
      end
    end

    def handle_index(file_summary)
      return unless format == 'html'
      index = Formatters::HtmlIndex.new(file_summary)
      @last_file = File.join(index.output_path, index.filename)
      index.export
    end

    def root_path
      "doc/fukuzatsu"
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
      puts "Results written to #{root_path} "
      report_complexity
    end

    def report_complexity
      return if threshold.to_i == 0
      return if complexities.max.to_i <= options['threshold']
      puts "Maximum complexity of #{complexities.max} exceeds #{options['threshold']} threshold!"
      exit 1
    end

    def results_files
      summaries.map{|s| s[:results_file]}
    end

  end

end