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


  let(:parsed_file) { Struct.new(:path_to_file, :class_name, :average_complexity)}
  let(:mock_parsed_file) { parsed_file.new("fred/foo.rb", "Foo", 12) }
  let (:formatter) { Formatters::Text.new(mock_parsed_file) }

  describe "#header" do
    it "returns a header array" do
      expect(formatter.header).to eq ["Class/Module", "Method", "Complexity"]
    end
  end

  describe "#rows" do
    it "returns formatted rows" do
      allow(mock_parsed_file).to receive(:methods) { [method_1, method_2] }
      expect(formatter.rows).to eq(
        [["\e[31mFoo\e[0m", "\e[31m*initialize\e[0m", "\e[31m13\e[0m"], ["\e[33mFoo\e[0m", "\e[33m*report\e[0m", "\e[33m11\e[0m"]]
      )
    end
  end

end