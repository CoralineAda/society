module Fukuzatsu
  class ParsedFile

    attr_accessor :lines_of_code, :source
    attr_accessor :complexity, :path_to_file, :class_name, :path_to_results

    def initialize(path_to_file: path_to_file, class_name: class_name=nil, complexity: complexity)
      @path_to_file = path_to_file
      @class_name = class_name
      @lines_of_code = []
      @complexity = complexity
      @source = parse!
    end

    def average_complexity
      methods.map(&:complexity).reduce(:+) / methods.count.to_f
    end

    def class_name
      @class_name ||= this_class.full_name
    end

    def content
      @content ||= File.open(path_to_file, "r").read
    end

    def complexity
      @complexity ||= analyzer.complexity
    end

    def methods
      @methods ||= this_class.all_methods.map do |method_obj|
        ParsedMethod.new(
          name: method_obj.name,
          content: source[method_obj.location]
        )
      end
    end

    def parsed_content
      @parsed_content ||= Analyst.new(self.path_to_file)
    end

    def source
      return @source if @source
      end_pos = 0
      self.lines_of_code = []
      @source = File.readlines(self.path_to_file).each_with_index do |line, index|
        start_pos = end_pos + 1
        end_pos += line.size
        self.lines_of_code << LineOfCode.new(line_number: index + 1, range: (start_pos..end_pos))
        line
      end.join
    end

    def summary
      {
        path_to_file: self.path_to_file,
        results_file: self.path_to_results,
        source: source,
        class_name: self.class_name,
        complexity: complexity
      }
    end

    def this_class
      @this_class ||= parsed_content.classes.first
    end

    private

    def content
      @content ||= File.open(path_to_file, "r").read
    end

    def parse!
      end_pos = 0
      File.readlines(self.path_to_file).each_with_index do |line, index|
        start_pos = end_pos + 1
        end_pos += line.size
        self.lines_of_code << LineOfCode.new(line_number: index + 1, range: (start_pos..end_pos))
        line
      end.join
    end

  end
end
