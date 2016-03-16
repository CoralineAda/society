require 'spec_helper'

describe Society::Parser do
  let(:source)            { "class Ship; end" }
  let(:nested_source)     { "module Ship; class Anchor; end; end;" }
  let(:inherited_source)  { "class Carrier < Ship; end" }
  let(:namespaced_source) { "class Ship::Anchor; end" }

  describe "::for_source" do

    context "listing nodes" do
      it "returns a parser object" do
        expect(Society::Parser.for_source(source).class.name).to eq("Society::Parser")
      end

      it "will accept multiple source strings" do
        expect(Society::Parser.for_source(source, nested_source).class.name).to eq("Society::Parser")
      end

      it "parses simple source trees" do
        expect(Society::Parser.for_source(source).classes).to eq(["Ship"])
      end

      it "parses source trees with inheritance" do
        expect(Society::Parser.for_source(inherited_source).classes).to eq(["Carrier"])
      end

      it "parses namespaced nodes" do
        expect(Society::Parser.for_source(nested_source).classes).to eq(["Ship", "Ship::Anchor"])
        expect(Society::Parser.for_source(namespaced_source).classes).to eq(["Ship::Anchor"])
      end

      it "tracks if a node is a class or module" do
        parser = Society::Parser.for_source(nested_source)
        expect(parser.graph.select { |node| node.name == "Ship" }.first.type).to eq(:module)
        expect(parser.graph.select { |node| node.name == "Ship::Anchor" }.first.type).to eq(:class)
      end

    end

    context "detecting edges" do
      let(:source) { "class Ship; def initialize; @engine = Engine.new; end; end; class Engine; end;" }
      let(:namespaced_source) { "class Ship; def initialize; @engine = Engine::Diesel.new; end; end; class Engine::Diesel; end" }
      let(:unknown_edge_source) { "class Ship; def initialize; @engine = Engine::UFO.new; end; end" }

      it "detects simple edges for classes" do
        graph = Society::Parser.for_source(source).graph
        edge  = graph.first.edges.first
        expect(edge.class.name).to eq("Society::Edge")
        expect(graph.first.edges.map(&:to)).to eq(["Engine"])
      end

      it "detects simple edges for namespaced classes" do
        expect(Society::Parser.for_source(namespaced_source).graph.first.edges.map(&:to)).to eq(["Engine::Diesel"])
      end

      it "rejects edges which point to nodes of which it is unaware" do
        expect(Society::Parser.for_source(unknown_edge_source).graph.first.edges.empty?).to eq(true)
      end
    end

    context "detecting activerecord edges from belongs_to, has_many and through" do
      let(:source) {
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

      let(:parser)   { Society::Parser.for_source(source) }
      let(:assembly) { parser.graph.detect {|c| c.name == "Assembly" } }
      let(:manifest) { parser.graph.detect {|c| c.name == "Manifest" } }
      let(:part)     { parser.graph.detect {|c| c.name == "Part" } }

      it "records `has_many` and `has_many through:` associations" do
        expect(assembly.edges.map(&:to).sort).to match_array %w(Manifest Part)
        expect(part.edges.map(&:to).sort).to match_array %w(Assembly Manifest)
      end

      it "records `belongs_to` associations" do
        expect(manifest.edges.map(&:to).sort).to match_array %w(Assembly Part)
      end
    end

    context "detecting activerecord edges with `class_name` specified" do
      let(:source) {<<-CODE
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

      let(:parser)   { Society::Parser.for_source(source) }
      let(:user)     { parser.graph.detect {|c| c.name == "User" } }
      let(:post)     { parser.graph.detect {|c| c.name == "Post" } }

      it "records belongs_to's" do
        expect(post.edges.map(&:to)).to match_array %w(User)
        expect(post.edges.map(&:weight)).to match_array [2]
      end

      it "records has_many's" do
        expect(user.edges.map(&:to)).to match_array %w(Post)
        expect(user.edges.map(&:weight)).to match_array [2]
      end
    end

    context "detecting activerecord edges with `class_name` or `source` specified" do
      let(:source) { <<-CODE
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

      let(:parser)         { Society::Parser.for_source(source) }
      let(:user)           { parser.graph.detect {|c| c.name == "User" } }
      let(:post)           { parser.graph.detect {|c| c.name == "Post" } }
      let(:post_authoring) { parser.graph.detect {|c| c.name == "PostAuthoring" } }

      it "handles `source` and `class_name` correctly" do
        expect(post.edges.map(&:to).sort).to match_array %w(PostAuthoring User)
        expect(post.edges.sort_by(&:to).map(&:weight)).to match_array [1, 2]
      end

      it "handles `through` and `class_name` correctly" do
        expect(user.edges.map(&:to).sort).to match_array %w(PostAuthoring Post)
        expect(user.edges.sort_by(&:to).map(&:weight)).to match_array [1, 2]
      end

      it "handles `class_name` correctly" do
        expect(post_authoring.edges.map(&:to).sort).to match_array %w(Post User)
      end
    end

    context "detecting activerecord edges with polymorphic associations" do
      let(:source) { <<-CODE
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

      let(:parser)   { Society::Parser.for_source(source) }
      let(:picture)  { parser.graph.detect {|c| c.name == "Picture" } }
      let(:employee) { parser.graph.detect {|c| c.name == "Employee" } }
      let(:product)  { parser.graph.detect {|c| c.name == "Product" } }

      it "records the `polymorphic: true` side of the association" do
        expect(picture.edges.map(&:to).sort).to match_array %w(Employee Product)
      end

      it "records the `as: :something` side of the asociation" do
        expect(employee.edges.map(&:to).sort).to match_array %w(Picture)
        expect(product.edges.map(&:to).sort).to match_array %w(Picture)
      end

    end

  end

  describe "::for_files" do

    it "returns a parser object" do
      expect(Society::Parser.for_files('./spec/fixtures/for_parser_spec').class.name).to eq("Society::Parser")
      expect(Society::Parser.for_files('./spec/fixtures/for_parser_spec').classes).to eq(["Whaler"])
    end
  end

  describe "#initialize" do
    it "returns a parser object" do
      expect(Society::Parser.new([]).class.name).to eq("Society::Parser")
    end
  end

  describe "#graph" do
    it "returns a graph object" do
      expect(Society::Parser.new([]).graph.class.name).to eq("Society::ObjectGraph")
    end
  end

  describe "#report" do

    let(:parser) { Society::Parser.new([]) }
    let(:formatter) { double.as_null_object }

    before do
      allow(parser).to receive(:json_data).and_return('{"json": "is kewl"}')
    end

    context "with a valid format given" do
      it "instantiates a formatter" do
        expect(Society::Formatter::Report::HTML).to receive(:new).and_return(formatter)
        parser.report(:html)
      end

      it "triggers the formatter to write its results" do
        allow(Society::Formatter::Report::Json).to receive(:new).and_return(formatter)
        expect(formatter).to receive(:write)
        parser.report(:json)
      end
    end

    context "with an invalid format given" do
      it "raises an ArgumentError" do
        expect { parser.report(:haiku) }.to raise_error(ArgumentError)
      end
    end

  end

end
