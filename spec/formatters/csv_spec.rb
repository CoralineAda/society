require 'spec_helper'

describe Formatters::Csv do

  let(:formatter) { Formatters::Csv.new }

  describe "#header" do

    it "outputs a header row" do
      expect(formatter.header).to eq("class,method,complexity,lines")
    end

  end

end