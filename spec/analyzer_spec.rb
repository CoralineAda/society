require 'spec_helper'

describe Analyzer do

  let(:content_1)   { File.read("spec/fixtures/program_1.rb") }
  let(:content_2)   { File.read("spec/fixtures/program_2.rb") }

  context "program_1" do

    let(:analyzer)  { Analyzer.new(content_1) }

    it "returns a complexity of 4" do
      analyzer.parse!.should == 4
    end

  end

  context "program_2" do

    let(:analyzer)  { Analyzer.new(content_2) }

    it "returns a complexity of 5" do
      analyzer.parse!.should == 5
    end

  end

end