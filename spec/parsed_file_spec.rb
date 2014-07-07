require 'spec_helper'

describe ParsedFile do

  let(:parsed_file) { ParsedFile.new(path_to_file: "bar/foo.rb") }
  let(:analyzer)    { Analyzer.new("class Foo; end") }

  describe "#class_name" do
    before do
      allow(parsed_file).to receive(:analyzer) { analyzer }
    end
    it "retrieves class name from analyzer" do
      expect(parsed_file.class_name).to eq "Foo"
    end
  end

  describe "#content" do
    it "reads from file" do
      allow(File).to receive(:open).with("bar/foo.rb", "r") {
        instance_double("File", read: "whatever")
      }
      expect(parsed_file.content).to eq("whatever")
    end
  end

  describe "#analyzer" do
    it "instantiates an Analyzer instance with content" do
      allow(parsed_file).to receive("content") { "stuff" }
      expect(parsed_file.analyzer.class.name).to eq "Analyzer"
    end
  end

  describe "#complexity" do
    before do
      allow(parsed_file).to receive(:analyzer) { analyzer }
    end
    it "retrieves complexity score from analyzer" do
      allow(analyzer).to receive(:complexity) { 13 }
      expect(parsed_file.complexity).to eq 13
    end
  end

  describe "methods" do
    before do
      allow(parsed_file).to receive(:analyzer) { analyzer }
    end
    it "retrieves methods from analyzer" do
      allow(analyzer).to receive(:extract_methods) { [:talk, :walk] }
      expect(parsed_file.methods).to eq([:talk, :walk])
    end
  end

  describe "summary" do
    it "builds a hash" do
      allow(parsed_file).to receive(:path_to_results) { "doc/fukuzatsu/foo.rb.htm" }
      allow(parsed_file).to receive(:path_to_file) { "foo.rb.htm" }
      allow(parsed_file).to receive(:class_name) { "Foo" }
      allow(parsed_file).to receive(:complexity) { 11 }
      expect(parsed_file.summary[:results_file]).to eq "doc/fukuzatsu/foo.rb.htm"
      expect(parsed_file.summary[:path_to_file]).to eq "foo.rb.htm"
      expect(parsed_file.summary[:class_name]).to eq "Foo"
      expect(parsed_file.summary[:complexity]).to eq 11
    end
  end


end
