require 'spec_helper'

describe ParsedMethod do

  let(:parsed_method) { ParsedMethod.new }
  let(:analyzer)    { Analyzer.new("class Foo; end") }

  describe "#complexity" do
    it "retrieves complexity from its analyzer" do
      allow(parsed_method).to receive(:analyzer) { analyzer }
      allow(analyzer).to receive(:complexity) { 23 }
      expect(parsed_method.complexity).to eq 23
    end
  end

  describe "#analyzer" do
    it "instantiates an Analyzer instance with content" do
      allow(parsed_method).to receive("content") { "stuff" }
      expect(parsed_method.analyzer.class.name).to eq "Analyzer"
    end
  end

  describe "#prefix" do
    it "returns '.' if its type is class" do
      allow(parsed_method).to receive("type") { :class }
      expect(parsed_method.prefix).to eq "."
    end
    it "returns '#' if its type is instance" do
      allow(parsed_method).to receive("type") { :instance }
      expect(parsed_method.prefix).to eq "#"
    end
  end

end