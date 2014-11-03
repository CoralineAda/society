require 'spec_helper'

describe Fukuzatsu::Summary do

  describe "::from" do
    let(:content) { double(:content) }
    let(:parser) { double(:parser) }
    let(:entities) { ["UserClass", "AccountClass", "ActsOut", "ActsIn"] }

    before do
      allow(parser).to receive(:top_level_entities).and_return(entities)
      allow(Analyst::Parser).to receive(:from_source).with(content).and_return(parser)
    end

    it "generates summaries for each class and module" do
      expect(Fukuzatsu::Summary).to receive(:new).exactly(4).times
      Fukuzatsu::Summary.from(content: content, source_file: "foo")
    end

  end

  describe "#complexity" do

    let(:class_source) { File.open("./spec/fixtures/class.rb", "r").readlines }
    let(:class_complexity) { class_source.first.split('complexity:')[1].to_i }

    let(:module_source) { File.open("./spec/fixtures/module.rb", "r").readlines }
    let(:module_complexity) { module_source.first.split('complexity:')[1].to_i }

    let(:procedural_source) { File.open("./spec/fixtures/procedural.rb", "r").readlines }
    let(:procedural_complexity) { procedural_source.first.split('complexity:')[1].to_i }

    it "calculates complexity of a class" do
      summary = Fukuzatsu::Summary.from(content: class_source.join("\n")).first
      expect(summary.complexity).to eq(class_complexity)
    end

    it "calculates complexity of a module" do
      summary = Fukuzatsu::Summary.from(content: module_source.join("\n")).first
      expect(summary.complexity).to eq(module_complexity)
    end

    it "calculates complexity of procedural code" do
      summary = Fukuzatsu::Summary.from(content: procedural_source.join("\n")).first
      expect(summary.complexity).to eq(procedural_complexity)
    end

  end

end
