require 'spec_helper'

describe Formatters::Base do

  class TestFormatter
    include Formatters::Base
    def header; "class,method,complexity,loc"; end
    def rows; ["foo,bar,10,4","foo,baz,11,5"]; end
    def footer; "that's all folks!"; end
  end

  describe "#content" do

    let(:formatter) { TestFormatter.new }
    let(:expected)  { "class,method,complexity,loc\r\nfoo,bar,10,4\r\nfoo,baz,11,5\r\nthat's all folks!" }

    it "produces expected output" do
      expect(formatter.content).to eq expected
    end

  end

end