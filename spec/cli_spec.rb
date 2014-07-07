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

  describe "#complexities" do
    it "extracts complexities from its file summaries" do
      expect(cli.send(:complexities)).to eq([13,11])
    end
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

  describe "#report" do
    it "does not report if format is text" do
      allow(cli).to receive(:options) { {'format' => 'text'} }
      expect(cli.send(:report)).to be_nil
    end
  end

  describe "#report_complexity" do
    it "does not report if threshold is not set" do
      expect(cli.send(:report_complexity)).to be_nil
    end

    it "does not report if threshold is respected" do
      allow(cli).to receive(:options) { {'threshold' => 15} }
      allow(cli).to receive(:complexities) { [0,13,11] }
      expect(cli.send(:report_complexity)).to be_nil

    end
  end

  describe "#results_files" do
    it "extracts results files from its file summaries" do
      expect(cli.send(:results_files)).to eq(
        [
          "doc/fukuzatsu/file_1.rb.htm",
          "doc/fukuzatsu/file_2.rb.htm"
        ]
      )
    end
  end

end
