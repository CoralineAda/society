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
          if assigned_constant(const, klass)
            next
          elsif target = perfect_match_for(const)
            @references << Edge.new(from: klass,
                                    to: target,
                                    meta: {
                                      type: :perfect,
                                      entity: const})
          elsif target = partial_match_for(const)
            @references << Edge.new(from: klass,
                                    to: target,
                                    meta: {
                                      type: :partial,
                                      entity: const})
          else
            @unresolved_references << { class: klass,
                                        target_name: const.full_name,
                                        constant: const }
          end
        end
      end
    end

    def perfect_match_for(const)
      classes.detect { |klass| klass.full_name == const.name }
    end

    def partial_match_for(const)
      partial_matches = classes.select do |klass|
        klass.full_name.include? const.full_name
      end
      partial_matches.first if partial_matches.size == 1
    end

    def assigned_constant(const, klass)
      klass.constant_assignments.map(&:name).include? const.name
    end

  end

end

