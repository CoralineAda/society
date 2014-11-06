module Society

  class ReferenceProcessor

    attr_reader :classes, :references, :unresolved_references

    def initialize(classes)
      @classes = classes
      @references = []
      @unresolved_references = []
      process
    end

    private

    def process
      classes.each do |klass|
        klass.constants.each do |const|
          if target = class_by_name(const.full_name)
            @references << Edge.new(from: klass, to: target)
          else
            @unresolved_references << { class: klass,
                                        target_name: const.full_name,
                                        constant: const }
          end
        end
      end
    end

    def class_by_name(name)
      classes.detect { |klass| klass.full_name == name }
    end

  end

end

