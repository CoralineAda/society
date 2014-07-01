require 'spec_helper'

describe Analyzer do

  let(:content_1)   { File.read("spec/fixtures/program_1.rb") }
  let(:content_2)   { File.read("spec/fixtures/program_2.rb") }

  context "program_1" do

    let(:analyzer)  { Analyzer.new(content_1) }

    it "matches the manual calculation of complexity of 4" do
      expect(analyzer.parse!).to eq(4)
    end

  end

  context "program_2" do

    let(:analyzer)  { Analyzer.new(content_2) }

    it "matches the manual calculation of complexity of 5" do
      expect(analyzer.parse!).to eq(5)
    end

  end

end