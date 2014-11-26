require 'spec_helper'
require_relative '../lib/society/cli'

describe Society::CLI do

  describe "#from" do

    let(:parser) { Society::Parser.new(nil) }

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

  end

end

