require 'spec_helper'

describe "Formatters::Csv" do

  let (:method_1) { ParsedMethod.new(
      name: "initialize",
      complexity: 13,
      type: :instance
    )
  }
  let (:method_2) { ParsedMethod.new(
      name: "report",
      complexity: 11,
      type: :instance
    )
  }

  let(:parsed_file) { Struct.new(:path_to_file, :class_name) }
  let(:mock_parsed_file) { parsed_file.new("fred/foo.rb", "Foo") }
  let (:formatter) { Formatters::Csv.new(mock_parsed_file) }

  describe "#rows" do
    it "returns comma-separated rows" do
      allow(mock_parsed_file).to receive(:methods) { [method_1, method_2] }
      expect(formatter.rows).to eq(
        "fred/foo.rb,Foo,#initialize,13\r\nfred/foo.rb,Foo,#report,11"
      )
    end
  end

  describe "#file_extension" do
    it "returns the proper extension" do
      expect(formatter.file_extension).to eq ".csv"
    end
  end

end