require 'fileutils'
require 'analyst'

module Fukuzatsu

  class Parser

    attr_reader :path_to_files

    def initialize(path_to_files)
      @path_to_files = path_to_files
    end

    def report
      file_reader.source_files.each do |source_file|
        summaries = Fukuzatsu::Summary.from(
          content:     source_file.contents,
          source_file: source_file.filename
        )
        p summaries.map(&:to_s)
      end
      true
    end

    def file_reader
      @file_reader ||= Fukuzatsu::FileReader.new(self.path_to_files)
    end

  #   def parsed_files
  #     @parsed_files ||= source_files.map do |path_to_file|
  #        parse_source_file(path_to_file)
  #     end
  #   end

  #   def report
  #     reset_output_directory
  #     self.parsed_files.each do |file|
  #       print "."
  #       formatter.new(file, OUTPUT_DIRECTORY, file.source).export
  #     end
  #     puts
  #     write_report_index
  #     report_complexity
  #   end

    private

  #   def reset_output_directory
  #     begin
  #       FileUtils.remove_dir(OUTPUT_DIRECTORY)
  #     rescue Errno::ENOENT
  #     end
  #     FileUtils.mkpath(OUTPUT_DIRECTORY)
  #   end

    def source_files
      if File.directory?(start_path)
        return Dir.glob(File.join(start_path, "**", "*.rb"))
      else
        return [start_path]
      end
    end

  #   def parse_source_file(path_to_file, options={})
  #     ParsedFile.new(path_to_file: path_to_file)
  #   end

  #   def report_complexity
  #     return if self.threshold == 0
  #     complexities = self.parsed_files.map(&:complexity)
  #     return if complexities.max.to_i <= self.threshold
  #     puts "Maximum complexity of #{complexities.max} exceeds #{options['threshold']} threshold!"
  #     exit 1
  #   end

  #   def write_report_index
  #     return unless self.formatter.writes_to_file_system?
  #     puts "Results written to #{OUTPUT_DIRECTORY} "
  #     return unless self.formatter.has_index?
  #     formatter.index_class.new(parsed_files.map(&:summary), OUTPUT_DIRECTORY).export
  #   end

  end

end