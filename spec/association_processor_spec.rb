require 'spec_helper'

describe Society::AssociationProcessor do

  describe "#associations" do

    context "`belongs_to`, `has_many`, and `has_many through:` associations" do
      let(:code) {
        <<-CODE
          class Assembly < ActiveRecord::Base
            has_many :manifests
            has_many :parts, through: :manifests
          end

          class Manifest < ActiveRecord::Base
            belongs_to :assembly
            belongs_to :part
          end

          class Part < ActiveRecord::Base
            has_many :manifests
            has_many :assemblies, through: :manifests
          end
        CODE
      }

      let(:parser) { Society::Parser.for_source(code) }
      let(:processor) { Society::AssociationProcessor.new(parser.analyzer.classes) }
      let(:assembly) { processor.classes.detect {|c| c.name == "Assembly" } }
      let(:manifest) { processor.classes.detect {|c| c.name == "Manifest" } }
      let(:part) { processor.classes.detect {|c| c.name == "Part" } }

      it "records `has_many` and `has_many through:` associations" do
        assembly_associations = processor.associations.select { |edge| edge.from == assembly }
        expect(assembly_associations.map(&:to)).to match_array [manifest, part]

        part_associations = processor.associations.select { |edge| edge.from == part }
        expect(part_associations.map(&:to)).to eq [manifest, assembly]
      end

      it "records `belongs_to` associations" do
        manifest_associations = processor.associations.select { |edge| edge.from == manifest }
        expect(manifest_associations.map(&:to)).to match_array [assembly, part]
      end
    end

    context "associations with `class_name` specified" do
      let(:code) {<<-CODE
          class Post < ActiveRecord::Base
            belongs_to :author, :class_name => "User"
            belongs_to :editor, :class_name => "User"
          end

          class User < ActiveRecord::Base
            has_many :authored_posts, :foreign_key => "author_id", :class_name => "Post"
            has_many :edited_posts, :foreign_key => "editor_id", :class_name => "Post"
          end
        CODE
      }
      let(:parser) { Society::Parser.for_source(code) }
      let(:processor) { Society::AssociationProcessor.new(parser.analyzer.classes) }
      let(:user) { processor.classes.detect {|c| c.name == "User" } }
      let(:post) { processor.classes.detect {|c| c.name == "Post" } }

      it "records belongs_to's" do
        post_associations = processor.associations.select { |edge| edge.from == post }
        expect(post_associations.map(&:to)).to match_array [user, user]
      end

      it "records has_many's" do
        user_associations = processor.associations.select { |edge| edge.from == user }
        expect(user_associations.map(&:to)).to match_array [post, post]
      end
    end

    context "associations with `class_name` or `source` specified" do
      let(:code) { <<-CODE
        class Post < ActiveRecord::Base
          has_many :post_authorings, :foreign_key => :authored_post_id
          has_many :authors, :through => :post_authorings, :source => :post_author
          belongs_to :editor, :class_name => "User"
        end

        class User < ActiveRecord::Base
          has_many :post_authorings, :foreign_key => :post_author_id
          has_many :authored_posts, :through => :post_authorings
          has_many :edited_posts, :foreign_key => :editor_id, :class_name => "Post"
        end

        class PostAuthoring < ActiveRecord::Base
          belongs_to :post_author, :class_name => "User"
          belongs_to :authored_post, :class_name => "Post"
        end
      CODE
      }
      let(:parser) { Society::Parser.for_source(code) }
      let(:processor) { Society::AssociationProcessor.new(parser.analyzer.classes) }
      let(:user) { processor.classes.detect {|c| c.name == "User" } }
      let(:post) { processor.classes.detect {|c| c.name == "Post" } }
      let(:post_authoring) { processor.classes.detect {|c| c.name == "PostAuthoring" } }

      it "handles `source` and `class_name` correctly" do
        post_associations = processor.associations.select { |edge| edge.from == post }
        expect(post_associations.map(&:to)).to match_array [post_authoring, user, user]
      end

      it "handles `through` and `class_name` correctly" do
        user_associations = processor.associations.select { |edge| edge.from == user }
        expect(user_associations.map(&:to)).to match_array [post_authoring, post, post]
      end

      it "handles `class_name` correctly" do
        pa_associations = processor.associations.select { |edge| edge.from == post_authoring }
        expect(pa_associations.map(&:to)).to match_array [user, post]
      end
    end

    context "polymorphic associations" do
      let(:code) { <<-CODE
        class Picture < ActiveRecord::Base
          belongs_to :imageable, polymorphic: true
        end

        class Employee < ActiveRecord::Base
          has_many :pictures, as: :imageable
        end

        class Product < ActiveRecord::Base
          has_many :pictures, as: :imageable
        end
      CODE
      }
      let(:parser) { Society::Parser.for_source(code) }
      let(:processor) { Society::AssociationProcessor.new(parser.analyzer.classes) }
      let(:picture) { processor.classes.detect {|c| c.name == "Picture" } }
      let(:employee) { processor.classes.detect {|c| c.name == "Employee" } }
      let(:product) { processor.classes.detect {|c| c.name == "Product" } }

      it "records the `polymorphic: true` side of the association" do
        picture_associations = processor.associations.select { |edge| edge.from == picture }
        expect(picture_associations.map(&:to)).to match_array [employee, product]
      end

      it "records the `as: :something` side of the asociation" do
        employee_associations = processor.associations.select { |edge| edge.from == employee }
        expect(employee_associations.map(&:to)).to match_array [picture]

        product_associations = processor.associations.select { |edge| edge.from == product }
        expect(product_associations .map(&:to)).to match_array [picture]
      end
    end

    context "self joins" do
      let(:code) {<<-CODE
        class Employee < ActiveRecord::Base
          has_many :subordinates, class_name: "Employee",
                                  foreign_key: "manager_id"

          belongs_to :manager, class_name: "Employee"
        end
      CODE
      }
      let(:parser) { Society::Parser.for_source(code) }
      let(:processor) { Society::AssociationProcessor.new(parser.analyzer.classes) }
      let(:employee) { processor.classes.detect {|c| c.name == "Employee" } }

      it "records self joins" do
        employee_associations = processor.associations.select { |edge| edge.from == employee }
        expect(employee_associations.map(&:to)).to match_array [employee, employee]
      end
    end
  end
end

