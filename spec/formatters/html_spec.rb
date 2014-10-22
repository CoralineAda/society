require 'spec_helper'

describe "Formatters::Text" do

  let(:parsed_file) { Struct.new(:path_to_file, :class_name)}
  let(:mock_parsed_file) { parsed_file.new("fred/foo.rb", "Foo") }
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
  let (:formatter) { Formatters::Html.new(mock_parsed_file) }

  before do
    allow(mock_parsed_file).to receive(:methods) { [method_1, method_2] }
  end

  describe "#header" do
    it "returns an HTML-formatted header" do
      expect(formatter.header).to eq(
        "<th>Class</th>\r\n<th>Method</th>\r\n<th>Complexity</th>"
      )
    end
  end

  describe "#rows" do
    it "returns HTML-formatted rows" do
      expected = "<tr class='even'>\r\n  <td>Foo</td>\r\n  <td>#initialize</td>\r\n  <td>13</td>\r\n</tr>\r\n"
      expected << "<tr class='odd'>\r\n  <td>Foo</td>\r\n  <td>#report</td>\r\n  <td>11</td>\r\n</tr>"
      allow(mock_parsed_file).to receive(:methods) { [method_1, method_2] }
      expect(formatter.rows).to eq(expected)
    end
  end

  describe "#file_extension" do
    it "returns the proper extension" do
      expect(formatter.file_extension).to eq ".htm"
    end
  end

end