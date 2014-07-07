require 'spec_helper'

describe "Formatters::Csv" do

  let (:parsed_file) { ParsedFile.new(class_name: "Foo") }
  let (:method_1) { ParsedMethod.new(
      name: "initialize",
      complexity: 13,
      type: "instance"
    )
  }
  let (:method_2) { ParsedMethod.new(
      name: "report",
      complexity: 11,
      type: "instance"
    )
  }
  let (:formatter) { Formatters::Csv.new(parsed_file) }

  describe "#header" do
    it "returns a comma-separated header" do
      expect(formatter.header).to eq "class,method,complexity"
    end
  end

  describe "#rows" do
    it "returns comma-separated rows" do
      allow(parsed_file).to receive(:methods) { [method_1, method_2] }
      expect(formatter.rows).to eq(
        "Foo,#initialize,13\r\nFoo,#report,11"
      )
    end
  end

  describe "#file_extension" do
    it "returns the proper extension" do
      expect(formatter.file_extension).to eq ".csv"
    end
  end

end