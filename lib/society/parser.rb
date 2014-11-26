module Society

  class Parser

    def self.for_files(file_path)
      new(::Analyst.for_files(file_path))
    end

    def self.for_source(source)
      new(::Analyst.for_source(source))
    end

    attr_reader :analyzer

    def initialize(analyzer)
      @analyzer = analyzer
    end

    def report(format, output_path=nil)
      raise ArgumentError, "Unknown format #{format}" unless known_formats.include?(format)
      options = { json_data: json_data }
      options[:output_path] = output_path unless output_path.nil?
      FORMATTERS[format].new(options).write
    end

    private

    FORMATTERS = {
      html: Society::Formatter::Report::HTML,
      json: Society::Formatter::Report::Json
    }

    def classes
      @classes ||= analyzer.classes
    end

    def class_graph
      @class_graph ||= begin
        associations = associations_from(classes) + references_from(classes)
        # TODO: merge identical classes, and (somewhere else) deal with
        #       identical associations too. need a WeightedEdge, and each
        #       one will be unique on [from, to], but will have a weight

        ObjectGraph.new(nodes: classes, edges: associations)
      end
    end

    def json_data
      Society::Formatter::Graph::JSON.new(class_graph).to_json
    end

    def known_formats
      FORMATTERS.keys
    end

    def associations_from(all_classes)
      @association_processor ||= AssociationProcessor.new(all_classes)
      @association_processor.associations
    end

    def references_from(all_classes)
      @reference_processor ||= ReferenceProcessor.new(all_classes)
      @reference_processor.references
    end

  end

end

