require 'spec_helper'

describe ParsedFile do

  let(:parsed_file) { ParsedFile.new(path_to_file: "./spec/fixtures/eg_class.rb") }
  let(:analyzer)    { Analyzer.new("class Foo; end") }

  describe "::average_complexity" do

    let(:method) { Struct.new(:complexity) }
    before do
      allow(parsed_file).to receive(:methods) {
        [
          method.new(10),
          method.new(20),
          method.new(30)
        ]
      }
    end

    it "averages complexity of n methods" do
      expect(parsed_file.average_complexity).to eq(20)
    end
  end

  describe "::class_name" do
    before do
      allow(parsed_file).to receive(:analyzer) { analyzer }
    end
    it "retrieves class name from analyzer" do
      expect(parsed_file.class_name).to eq "Foo"
    end
  end

  describe "::content" do
    it "reads from file" do
      allow(File).to receive(:open).with("./spec/fixtures/eg_class.rb", "r") {
        instance_double("File", read: "whatever")
      }
      expect(parsed_file.send(:content)).to eq("whatever")
    end
  end

  describe "::complexity" do
    before do
      allow(parsed_file).to receive(:analyzer) { analyzer }
    end
    it "retrieves complexity score from analyzer" do
      allow(analyzer).to receive(:complexity) { 13 }
      expect(parsed_file.complexity).to eq 13
    end
  end

  describe "::methods" do
    before do
      allow(parsed_file).to receive(:analyzer) { analyzer }
    end
    it "retrieves methods from analyzer" do
      expect(parsed_file.methods).to match_array(["look_at_stuff", "say_hello"])
    end
  end

  describe "::summary" do
    it "builds a hash" do
      allow(parsed_file).to receive(:path_to_results) { "doc/fukuzatsu/spec/fixtures/eg_class.rb" }
      allow(parsed_file).to receive(:path_to_file) { "eg_class.rb.htm" }
      allow(parsed_file).to receive(:class_name) { "Foo" }
      allow(parsed_file).to receive(:complexity) { 11 }
      expect(parsed_file.summary[:results_file]).to eq "doc/fukuzatsu/spec/fixtures/eg_class.rb"
      expect(parsed_file.summary[:path_to_file]).to eq "eg_class.rb.htm"
      expect(parsed_file.summary[:class_name]).to eq "Foo"
      expect(parsed_file.summary[:complexity]).to eq 11
    end
  end


end
