module Society

  class AssociationProcessor

    ACTIVE_MODEL_ASSOCIATIONS = %w[belongs_to has_one has_many has_and_belongs_to_many]

    attr_reader :classes, :associations, :unresolved_associations

    def initialize(classes)
      @classes = classes
      process
    end

    private

    def process
      default_resolver = DefaultResolver.new(classes)
      through_resolver = ThroughResolver.new(classes)
      poly_resolver = PolymorphicResolver.new(default_resolver)

      classes.each do |klass|
        klass.macros.select do |macro|
          ACTIVE_MODEL_ASSOCIATIONS.include?(macro.name)
          # TODO: make sure macro.target is 'self' (it pretty much always will be)
        end.each do |association|
          through_resolver.process(association, klass) or
            poly_resolver.process(association, klass) or
            default_resolver.process(association, klass)
        end
      end

      @associations = default_resolver.associations
      @unresolved_associations = default_resolver.unresolved_associations

      @associations.concat(poly_resolver.associations).concat(through_resolver.associations)
      @unresolved_associations.concat(through_resolver.unresolved_associations)
    end


    class ThroughResolver

      attr_reader :associations, :unresolved_associations

      def initialize(classes)
        @classes = classes
        @my_own_default_resolver = DefaultResolver.new(classes)
        @associations = []
        @unresolved_associations = []
      end

      def process(association, klass)
        return false unless thru = through_of(association)

        if source_type = association.arguments.last.to_hash[:source_type]
          target = @classes.detect { |cls| cls.full_name == source_type }
        else
          joiner = klass.macros.detect do |macro|
            ACTIVE_MODEL_ASSOCIATIONS.include?(macro.name) && macro.arguments.first.value == thru
          end
          joining_class_entities = @my_own_default_resolver.all_classes_for(joiner)

          source_str = source_of(association).to_s

          target = joining_class_entities.reduce(nil) do |_,cls|
            assoc = find_association_in(cls, source_str)
            break @my_own_default_resolver.process(assoc, cls) if assoc
          end
        end

        if target
          @associations << Edge.new(from: klass,
                                    to: target,
                                    meta: {
                                      type: :through_association,
                                      macro: association })
        else
          @unresolved_associations << { class: klass,
                                        macro: association,
                                        thru_macro: joiner,
                                        joining_classes: joining_class_entities }
        end
        true
      end

      private

      def find_association_in(klass, name)
        klass.macros.detect do |macro|
          ACTIVE_MODEL_ASSOCIATIONS.include?(macro.name) &&
            macro.arguments.first.value.to_s.singularize == name.singularize
        end
      end

      def through_of(association)
        last_arg = association.arguments.last
        last_arg.is_a?(Analyst::Entities::Hash) && last_arg.to_hash[:through]
      end

      def source_of(association)
        association.arguments.last.to_hash[:source] || association.arguments.first.value
      end

    end


    class DefaultResolver

      attr_reader :associations, :unresolved_associations

      def initialize(classes)
        @classes = classes
        @associations = []
        @unresolved_associations = []
      end

      def process(association, klass)
        if target = all_classes_for(association).first
          @associations << Edge.new(from: klass,
                                    to: target,
                                    meta: {
                                      type: :association,
                                      macro: association })
        else
          @unresolved_associations << { class: klass,
                                        target_name: target_class_name_for(association),
                                        macro: association }
        end
        target
      end

      def all_classes_for(association)
        target_name = target_class_name_for(association)
        classes.select { |klass| klass.full_name == target_name }
      end

      private

      attr_reader :classes

      def target_class_name_for(association)
        last_arg = association.arguments.last
        if last_arg.is_a? Analyst::Entities::Hash
          target_name = last_arg.to_hash[:class_name]
        end
        target_name ||= association.arguments.first.value.to_s.pluralize.classify
      end

    end


    class PolymorphicResolver

      def initialize(default_resolver)
        @default_resolver = default_resolver
        @polymorphics = []
        @ases = []
      end

      # stores off any `polymorphic: true` or `as: :something` associations for
      # later processing. also does default processing on `as: :something`
      # associations. returns true iff association requires no further processing.
      def process(association, klass)
        last_arg = association.arguments.last
        return false unless last_arg.is_a?(Analyst::Entities::Hash)

        opts = last_arg.to_hash
        if opts.key? :polymorphic
          @polymorphics << { class: klass,
                            key: association.arguments.first.value,
                            macro: association }
          return true

        elsif opts.key? :as
          if target = @default_resolver.process(association, klass)
            @ases << { class: klass, target: target,
                      macro: association, key: opts[:as] }
          end
          return true
        end

        false
      end

      def associations
        associations = []
        @polymorphics.each do |poly|
          matching = @ases.select do |as|
            as[:key] == poly[:key] && as[:target] == poly[:class]
          end
          matching.each do |as|
            associations << Edge.new(from: poly[:class],
                                      to: as[:class],
                                      meta: {
                                        type: :polymorphic_association,
                                        macro: poly[:macro],
                                        complement: as[:macro] })
          end
        end
        associations
      end
    end

  end

end

