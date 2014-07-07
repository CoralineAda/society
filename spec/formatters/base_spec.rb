require 'spec_helper'

describe "Formatters::Base" do

  class Formatters::Sample; include Formatters::Base; end

  let (:parsed_file) { ParsedFile.new(class_name: "Foo", path_to_file: "lib/foo.rb") }
  let (:formatter) { Formatters::Sample.new(parsed_file) }

  before do
    allow(formatter).to receive(:header) { "class,method,complexity" }
    allow(formatter).to receive(:rows) { "Foo,#initialize,24" }
    allow(formatter).to receive(:footer) { "TOTAL,,24" }
  end

  describe "#columns" do
    it "returns default columns" do
      expect(formatter.columns).to eq(["class", "method", "complexity"])
    end
  end

  describe "#content" do
    it "returns expected content" do
      expect(formatter.content).to eq "class,method,complexity\r\nFoo,#initialize,24\r\nTOTAL,,24"
    end
  end

  describe "#filename" do
    it "builds a filename" do
      allow(formatter).to receive(:file_extension) { '.doc' }
      expect(formatter.filename).to eq "foo.rb.doc"
    end
  end

  describe "#output_path" do
    it "builds a path" do
      allow(FileUtils).to receive(:mkpath)
      expect(formatter.output_path).to eq "doc/fukuzatsu/lib"
    end
  end

  describe "#path_to_results" do
    it "builds a path" do
      allow(formatter).to receive(:file_extension) { '.doc' }
      allow(formatter).to receive(:output_path) { 'doc/fukuzatsu/lib' }
      expect(formatter.path_to_results).to eq "doc/fukuzatsu/lib/foo.rb.doc"
    end
  end

  describe "#root_path" do
    it "returns the expected path" do
      expect(formatter.root_path).to eq "doc/fukuzatsu"
    end
  end

end