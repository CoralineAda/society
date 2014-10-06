require 'fileutils'

module Fukuzatsu

  class Parser

    attr_reader :start_path, :parsed_files
    attr_reader :threshold, :formatter

    OUTPUT_DIRECTORY = "doc/fukuzatsu"

    def initialize(path, formatter, threshold=0)
      @start_path = path
      @formatter  = formatter
      @threshold  = threshold
      reset_output_directory
    end

    def parse_files
      @parsed_files = source_files.map do |path_to_file|
        parse_source_file(path_to_file)
      end
    end

    def report
      self.parsed_files.each{ |file| formatter.new(file, file.source).export }
      puts "Results written to #{OUTPUT_DIRECTORY} "
      write_report_index
      report_complexity
    end

    private

    def reset_output_directory
      begin
        FileUtils.remove_dir(OUTPUT_DIRECTORY)
      rescue Errno::ENOENT
      end
      FileUtils.mkpath(OUTPUT_DIRECTORY)
    end

    def source_files
      if File.directory?(start_path)
        return Dir.glob(File.join(start_path, "**", "*.rb"))
      else
        return [start_path]
      end
    end

    def parse_source_file(path_to_file, options={})
      ParsedFile.new(path_to_file: path_to_file)
    end

    def report_complexity
      return if self.threshold == 0
      complexities = self.parsed_files.map(&:complexity)
      return if complexities.max.to_i <= self.threshold
      puts "Maximum complexity of #{complexities.max} exceeds #{options['threshold']} threshold!"
      exit 1
    end

    def write_report_index
      self.formatter.has_index? && formatter.index_class.new(parsed_files.map(&:summary)).export
    end

  end

end