module Society

  class AssociationProcessor

    ACTIVE_MODEL_ASSOCIATIONS = %w[belongs_to has_one has_many has_and_belongs_to_many]

    attr_reader :classes, :associations, :unresolved_associations

    def initialize(classes)
      @classes = classes
      @associations = []
      @unresolved_associations = []
      process
    end

    private

    def process
      classes.each do |klass|
        klass.macros.select do |macro|
          ACTIVE_MODEL_ASSOCIATIONS.include?(macro.name)
          # TODO: make sure macro.target is 'self' (it pretty much always will be)
        end.each do |association|
          target_name = target_class_of(association)
          if target = class_by_name(target_name)
            @associations << Edge.new(from: klass, to: target, meta: association)
          else
            @unresolved_associations << { class: klass,
                                          target_name: target_name,
                                          macro: association }
          end
        end
      end
    end

    def target_class_of(association)
      last_arg = association.arguments.last
      if last_arg.is_a? Analyst::Entities::Hash
        target_class = last_arg.to_hash[:class_name]
      end
      target_class ||= association.arguments.first.value.to_s.pluralize.classify
    end

    def class_by_name(name)
      classes.detect { |klass| klass.full_name == name }
    end

  end

end

