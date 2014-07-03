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
