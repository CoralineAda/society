require 'spec_helper'

describe Formatters::Csv do

  let(:formatter) { Formatters::Csv.new }

  describe "#header" do
    it "outputs a header row" do
      expect(formatter.header).to eq("class,method,complexity,lines")
    end
  end

  describe "#rows" do

    let(:expected) {
      [
        "Foo,baz,5,10",
        "Foo,bat,15,100",
        "Bar,gum,51,110",
        "Bar,bun,55,101"
      ]
    }

    let(:file_1)    { ParsedFile.new(class_name: "Foo") }
    let(:file_2)    { ParsedFile.new(class_name: "Bar") }
    let(:method_1)  { ParsedMethod.new(method_name: "baz", complexity: 5, loc: 10)}
    let(:method_2)  { ParsedMethod.new(method_name: "bat", complexity: 15, loc: 100)}
    let(:method_3)  { ParsedMethod.new(method_name: "gum", complexity: 51, loc: 110)}
    let(:method_4)  { ParsedMethod.new(method_name: "bun", complexity: 55, loc: 101)}

    before do
      file_1.parsed_methods = [method_1, method_2]
      file_2.parsed_methods = [method_3, method_4]
      formatter.parsed_files = [file_1, file_2]
    end

    it "builds an array" do
      expect(formatter.rows).to eq(expected)
    end
  end

end