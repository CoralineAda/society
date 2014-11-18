require 'spec_helper'

describe Fukuzatsu::Formatters::Text do

  let (:summary) { Fukuzatsu::Summary.new(
      :source => "foo.rb",
      :entity => "Foo",
      :container => "Foo",
      :summaries => []
    )
  }

  let (:formatter) { Fukuzatsu::Formatters::Text.new(summary: summary) }

  describe "#header" do
    it "returns a header array" do
      expect(formatter.header).to eq ["Class/Module", "Method", "Complexity"]
    end
  end

  describe "#rows" do

    before do
      allow(summary).to receive(:container_name).and_return("Foo")
      allow(summary).to receive(:entity_name).and_return("*")
      allow(summary).to receive(:complexity).and_return(13)
      allow(summary).to receive(:averge_complexity).and_return(11)
    end

    it "returns formatted rows" do
      expect(formatter.rows).to eq(
        [
          ["\e[31mFoo\e[0m", "\e[31m*\e[0m", "\e[31m13\e[0m"]
        ]
      )
    end
  end

end