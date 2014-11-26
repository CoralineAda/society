require 'spec_helper'

describe Society::Parser do

  describe "::for_files" do

    it "returns a parser object" do
      expect(Society::Parser.for_files('./spec/fixtures').class.name).to eq("Society::Parser")
    end

    it "initializes the parser with an Analyzer object" do
      expect(Society::Parser.for_files('./spec/fixtures').analyzer.class.name).to eq("Analyst::Parser")
    end

  end

  describe "::for_source" do

    let(:source) { "class Ship; end" }

    it "returns a parser object" do
      expect(Society::Parser.for_source(source).class.name).to eq("Society::Parser")
    end

    it "initializes the parser with an Analyzer object" do
      expect(Society::Parser.for_source(source).analyzer.class.name).to eq("Analyst::Parser")
    end

  end

  describe "#report" do

    let(:parser) { Society::Parser.new(nil) }
    let(:formatter) { double.as_null_object }

    before do
      allow(parser).to receive(:json_data).and_return('{"json": "is kewl"}')
    end

    context "with a valid format given" do
      it "instantiates a formatter" do
        expect(Society::Formatter::Report::HTML).to receive(:new).and_return(formatter)
        parser.report(:html)
      end

      it "triggers the formatter to write its results" do
        allow(Society::Formatter::Report::Json).to receive(:new).and_return(formatter)
        expect(formatter).to receive(:write)
        parser.report(:json)
      end
    end

    context "with an invalid format given" do
      it "raises an ArgumentError" do
        expect { parser.report(:haiku) }.to raise_error(ArgumentError)
      end
    end

  end

end
