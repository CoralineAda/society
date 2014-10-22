require 'spec_helper'

describe "Fukuzatsu::CLI" do

  let(:cli) { Fukuzatsu::CLI.new([
      path: "foo/bar.rb",
      format: 'text'
    ]
  )}

  let(:summary_1) {
    {
      results_file: "doc/fukuzatsu/file_1.rb.htm",
      path_to_file: "file_1.rb",
      class_name: "File_1",
      complexity: 13
    }
  }

  let(:summary_2) {
    {
      results_file: "doc/fukuzatsu/file_2.rb.htm",
      path_to_file: "file_2.rb",
      class_name: "File_2",
      complexity: 11
    }
  }

  before do
    allow(cli).to receive(:summaries) { [summary_1, summary_2] }
  end

  describe "#formatter" do
    it "returns a csv formatter" do
      allow(cli).to receive(:options) { {'format' => 'csv'} }
      expect(cli.send(:formatter)).to eq Formatters::Csv
    end
    it "returns an html formatter" do
      allow(cli).to receive(:options) { {'format' => 'html'} }
      expect(cli.send(:formatter)).to eq Formatters::Html
    end
    it "returns a text formatter" do
      allow(cli).to receive(:options) { {'format' => 'text'} }
      expect(cli.send(:formatter)).to eq Formatters::Text
    end
  end

end
