require 'spec_helper'

describe Society::Formatter::Report::Json do

  before do # don't actually change the filesystem
    allow(FileUtils).to receive(:mkpath)
    allow(File).to receive(:open)
  end

  let(:json_data) { {foo: 'bar'}.to_json }

  describe "(private) #prepare_output_directory" do
    context "with output path specified" do

      let(:output_path) { File.join(%w[blah mah_data.json]) }
      let(:report) do
        Society::Formatter::Report::Json.new(
          json_data: json_data,
          output_path: output_path
        )
      end

      it "creates the output directory" do
        output_directory_matcher = /blah/
        expect(FileUtils).to receive(:mkpath).with(output_directory_matcher)
        report.send(:prepare_output_directory)
      end
    end

    context "with no output path specified" do

      let(:default_path) { 'society_graph.json' }
      let(:report) do
        Society::Formatter::Report::Json.new(
          json_data: json_data
        )
      end

      it "does not create a directory" do
        expect(FileUtils).to receive(:mkpath).with('.')
        report.send(:prepare_output_directory)
      end
    end
  end

  describe "#write" do

    let(:output_path) { File.join(%w[blah mah_data.json]) }
    let(:report) do
      Society::Formatter::Report::Json.new(
        json_data: json_data,
        output_path: output_path
      )
    end

    let(:open_file) { double }

    it "writes the json data" do
      expect(File).to receive(:open).with(output_path, 'w') do |path, mode, &block|
        block.yield open_file
      end
      expect(open_file).to receive(:write).with(json_data)
      report.write
    end
  end
end
