require 'spec_helper'

describe Society::Analyzer do

  let(:source) { File.open("./spec/fixtures/foo.rb", "r").read }
  let(:analyzer) { Society::Analyzer.new(source) }

  describe "#initialize" do
    it "assigns its content" do
      expect(analyzer.content).to eq(source)
    end
  end

  describe "#class_name" do
    xit "doesn't get confused by multiple class declarations in one file"

    it "returns a class name" do
      expect(analyzer.class_name).to eq "Foo"
    end
  end

  describe "#methods" do
    it "returns a list of methods from its source" do
      expected = ["#penultimate_method", "#initial_method", "#external_call", "#ultimate_method"]
      expect(analyzer.methods.map(&:name)).to eq(expected)
    end
  end

  describe "constants" do
    it "returns a list of classes" do
      expected = ["Bar"]
      expect(analyzer.constants).to eq(expected)
    end
  end

end