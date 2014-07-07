require 'spec_helper'

describe "Formatters::Text" do

  let (:parsed_file) { ParsedFile.new(class_name: "Foo", complexity: 11) }
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
  let (:formatter) { Formatters::Text.new(parsed_file) }

  describe "#header" do
    it "returns a tab-separated header" do
      expect(formatter.header).to eq "Foo\t\t11"
    end
  end

  describe "#rows" do
    it "returns tab-separated rows" do
      allow(parsed_file).to receive(:methods) { [method_1, method_2] }
      expect(formatter.rows).to eq(
        ["Foo\t#initialize\t13", "Foo\t#report\t11"]
      )
    end
  end

end