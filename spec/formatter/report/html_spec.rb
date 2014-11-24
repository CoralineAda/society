require 'spec_helper'

describe Society::Formatter::Report::HTML do

  before do # don't actually change the filesystem
    allow(FileUtils).to receive(:mkpath)
    allow(File).to receive(:open)
  end

  let(:json_data) { {foo: 'bar'}.to_json }

  describe "(private) #prepare_output_directory" do

    context "with output directory specified" do

      let(:output_directory) { "./doc" }
      let(:report) do
        Society::Formatter::Report::HTML.new(
          json_data: json_data,
          output_path: output_directory
        )
      end

      it "creates the output directory" do
        output_directory_matcher = Regexp.new(output_directory)
        expect(FileUtils).to receive(:mkpath).with(output_directory_matcher)
        report.send(:prepare_output_directory)
      end
    end

    context "with no output directory specified" do

      let(:default_directory) { File.join(%w[doc society]) }
      let(:report) do
        Society::Formatter::Report::HTML.new(
          json_data: json_data
        )
      end

      it "creates the default output directory" do
        default_directory_matcher = Regexp.new(default_directory)
        expect(FileUtils).to receive(:mkpath).with(default_directory_matcher)
        report.send(:prepare_output_directory)
      end
    end
  end

  describe "#write" do
    let(:output_directory) { "./doc" }
    let(:report) do
      Society::Formatter::Report::HTML.new(
        json_data: json_data,
        output_path: output_directory
      )
    end
    let(:society_css_path) { Regexp.new(File.join(%w[society-assets society.css])) }
    let(:society_js_path) { Regexp.new(File.join(%w[society-assets society.js])) }
    let(:d3_js_path) { Regexp.new(File.join(%w[d3 d3.min.js])) }
    let(:output_directory_matcher) { Regexp.new(output_directory) }

    it "copies bower assets to output dir" do
      expect(FileUtils).to receive(:cp).with(society_css_path, output_directory_matcher)
      expect(FileUtils).to receive(:cp).with(society_js_path, output_directory_matcher)
      expect(FileUtils).to receive(:cp).with(d3_js_path, output_directory_matcher)
      report.write
    end

    it "writes the html index file" do
      index_path_matcher = Regexp.new('index.htm')
      expect(File).to receive(:open).with(index_path_matcher, 'w')
      report.write
    end
  end
end

