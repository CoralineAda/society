require 'spec_helper'

describe "Formatters::HtmlIndex" do

  let(:file_summary) {
    [
      {
        results_file: "doc/fukuzatsu/file_1.rb.htm",
        path_to_file: "file_1.rb",
        class_name: "File_1",
        complexity: 13
      },
      {
        results_file: "doc/fukuzatsu/file_2.rb.htm",
        path_to_file: "file_2.rb",
        class_name: "File_2",
        complexity: 11
      }
    ]
  }

  let (:formatter) { Formatters::HtmlIndex.new(file_summary) }

  describe "::initialize" do
    it "initializes with a file summary" do
      expect(formatter.file_summary).to eq file_summary
    end
  end

  describe "::filename" do
    it "returns the expected filename" do
      expect(formatter.filename).to eq "index.htm"
    end
  end

end