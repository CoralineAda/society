require 'spec_helper'
require_relative '../lib/society/cli'

describe Society::CLI do

  describe "#from" do

    let(:parser) { Society::Parser.new([]) }

    it "invokes Society with a path" do
      allow(parser).to receive(:report)
      expect(Society).to receive(:new) { parser }
      Society::CLI.new.from("./spec/fixtures")
    end

    it "calls report on a Parser instance" do
      expect(parser).to receive(:report)
      allow(Society).to receive(:new) { parser }
      Society::CLI.new.from("./spec/fixtures")
    end

    it "handles globs" do
      expect(parser).to receive(:report)
      allow(Society).to receive(:new) { parser }
      Society::CLI.new.from("#{Dir.getwd}/lib/society/{parser.rb,node.rb}")
    end
  end

end
