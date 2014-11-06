module Society

  class AssociationProcessor

    ACTIVE_MODEL_ASSOCIATIONS = [:belongs_to, :has_one, :has_many, :has_and_belongs_to_many]

    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def associations
      @associations ||= klass.macros.select do |macro|
        ACTIVE_MODEL_ASSOCIATIONS.include?(macro.name.to_sym)
        # TODO: make sure macro.target is 'self' (it pretty much always will be)
      end.map do |association|
        Edge.new(from: klass.full_name, to: target_of(association))
      end
    end

    private

    def target_of(association)
      last_arg = association.arguments.last
      if last_arg.is_a? Analyst::Entities::Hash
        target_class = last_arg.to_hash[:class_name]
      end
      target_class ||= association.arguments.first.value.to_s.pluralize.classify
    end

  end

end
