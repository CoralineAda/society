require 'spec_helper'

describe Analyzer do

  let(:content_1)   { File.read("spec/fixtures/program_1.rb") }
  let(:content_2)   { File.read("spec/fixtures/program_2.rb") }
  let(:content_3)   { File.read("spec/fixtures/eg_class.rb") }
  let(:content_4)   { File.read("spec/fixtures/eg_mod_class.rb") }
  let(:content_5)   { File.read("spec/fixtures/eg_module.rb") }
  let(:content_6)   { File.read("spec/fixtures/eg_mod_class_2.rb") }

  context "#extract_class_name" do

    context "from Class Foo" do
      it "returns Foo" do
        expect(Analyzer.new(content_3).extract_class_name).to eq("Foo")
      end
    end

    context "from Module::Class Foo" do
      it "returns Foo::Bar" do
        expect(Analyzer.new(content_4).extract_class_name).to eq("Foo::Bar")
      end
    end

    context "from Module; Class" do
      it "returns Extracted::Thing" do
        expect(Analyzer.new(content_6).extract_class_name).to eq("Extracted::Thing")
      end
    end

    context "from Module" do
      it "returns Something" do
        expect(Analyzer.new(content_5).extract_class_name).to eq("Something")
      end
    end
  end

  describe "#complexity" do
    context "program_1" do

      let(:analyzer)  { Analyzer.new(content_1) }

      it "matches the manual calculation of complexity of 4" do
        expect(analyzer.complexity).to eq(4)
      end

    end

    context "program_2" do

      let(:analyzer)  { Analyzer.new(content_2) }

      it "matches the manual calculation of complexity of 5" do
        expect(analyzer.complexity).to eq(5)
      end

    end
  end

  describe "extract_class_name" do
    context "from a file with a class in it" do
      let(:analyzer) { Analyzer.new(File.read("spec/fixtures/single_class.rb")) }
      it "should return the name of the class" do
        expect(analyzer.extract_class_name).to eq "Gown"
      end
    end
    context "from a file with a class inside a module" do
      let(:analyzer) { Analyzer.new(File.read("spec/fixtures/module_with_class.rb")) }
      it "should return the name of the class" do
        expect(analyzer.extract_class_name).to eq "Symbolics::Insects::Bee"
      end
    end
    context "from a file with no class in it" do
      let(:analyzer) { Analyzer.new(File.read("spec/fixtures/single_method.rb")) }
      it "should return 'Unknown'" do
        expect(analyzer.extract_class_name).to eq "Unknown"
      end
    end

  end

  describe "extract_methods" do
    # Note: should implicitly trust private method #methods_from
    context "from a file with a single method" do
      let(:analyzer) { Analyzer.new(File.read("spec/fixtures/single_method.rb")) }
      it "should return a single method" do
        expect(analyzer.extract_methods.count).to eq 1
      end
      it "should extract the method name" do
        expect(analyzer.extract_methods[0].name).to eq "#read_poem"
      end
      it "should extract the method content" do
        expect(analyzer.extract_methods[0].content).to eq 'def read_poem
  return "I meant to find her when I came/Death had the same design"
end'
      end
      it "should set type to :instance" do
        expect(analyzer.extract_methods[0].type).to eq :instance
      end
    end
    context "from a file with multiple methods" do
      let(:analyzer) { Analyzer.new(File.read("spec/fixtures/multiple_methods.rb")) }
      it "should return multiple methods" do
        expect(analyzer.extract_methods.map { |m| m.name }).to eq ["#bake_treats", "#lower_from_window"]
      end
    end
    context "from a file with nested methods" do
      let(:analyzer) { Analyzer.new(File.read("spec/fixtures/nested_methods.rb")) }
      it "should return the root method, and its child" do
        expect(analyzer.extract_methods.map { |m| m.name }).to eq ["#grow_flowers", "#water_earth"]
      end
    end
    context "from a file with a class" do
      let(:analyzer) { Analyzer.new(File.read("spec/fixtures/single_class.rb")) }
      it "should return the class and its methods" do
        expect(analyzer.extract_methods.map { |m| m.name }).to eq ["#initialize", "#color"]
      end
    end
  end

end
