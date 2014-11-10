require 'fileutils'
require 'analyst'

module Fukuzatsu

  class Parser

    attr_reader :path_to_files, :formatter, :threshold

    def initialize(path_to_files, formatter, threshold)
      @path_to_files = path_to_files
      @formatter = formatter
      @threshold = threshold
    end

    def report
      self.formatter.reset_output_directory
      self.formatter.index(summaries)
      summaries.uniq(&:container_name).each do |summary|
        formatter = self.formatter.new(summary: summary)
        formatter.export
      end
      self.formatter.explain(summaries.count)
      check_complexity
    end

    private

     def check_complexity
      return if self.threshold == 0
      complexities = self.parsed_files.map(&:average_complexity)
      return if complexities.max.to_i <= self.threshold
      puts "Maximum average complexity of #{complexities.max} exceeds #{options['threshold']} threshold!"
      exit 1
    end

    def summaries
      @summaries ||= file_reader.source_files.map do |source_file|
        Fukuzatsu::Summary.from(
          content: source_file.contents,
          source_file: source_file.filename
        )
      end.flatten
    end

    def file_reader
      @file_reader ||= Fukuzatsu::FileReader.new(self.path_to_files)
    end

  end

end
