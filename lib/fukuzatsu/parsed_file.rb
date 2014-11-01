module Fukuzatsu
  class ParsedFile

    attr_accessor :path_to_file

    def initialize(path_to_file)
      @path_to_file = path_to_file
      @lines_of_code = []
    end

    def average_complexity
      parsed_methods.map(&:complexity).reduce(:+) / methods.count.to_f
    end

    def class_name
      @class_name ||= this_class.full_name
    end

    def complexity
      @complexity ||= Fukuzatsu::Analyzer.new(this_entity).complexity
    end

    def parsed_methods
      @parsed_methods ||= this_class.all_methods.map do |method_obj|
        ParsedMethod.new(
          name: method_obj.name,
          complexity: Fukuzatsu::Analyzer.new(method_obj).complexity
        )
      end
    end

    def parsed_content
      @parsed_content ||= Analyst.new(self.path_to_file)
    end

    def lines_of_code
      @lines_of_code ||= begin
        source_from_file.each_with_index do |line, index|
          end_pos ||= 0
          start_pos = end_pos + 1
          end_pos += line.size
          self.lines_of_code ||= []
          self.lines_of_code << LineOfCode.new(line_number: index + 1, range: (start_pos..end_pos))
          line
        end
      end.join
    end

    def summary
      {
        path_to_file: self.path_to_file,
        results_file: self.path_to_results,
        class_name: self.class_name,
        complexity: complexity
      }
    end

    def entity
      @this_class ||= parsed_content.classes.first
    end

    private

    def source_from_file
      @source_from_file ||= File.open(path_to_file, "r").read
    end

  end
end
