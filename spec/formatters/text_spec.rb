require 'spec_helper'

describe Fukuzatsu::Formatters::Text do

  let (:summary) { Struct.new(:source_file, :entity_name, :complexity) }
  let (:summary_1) { summary.new("foo.rb", "Foo", 13) }
  let (:summary_2) { summary.new("bar.rb", "Bar", 11) }
  let (:formatter) { Fukuzatsu::Formatters::Text.new(summaries: [ summary_1, summary_2]) }

  describe "#header" do
    it "returns a header array" do
      expect(formatter.header).to eq ["Class/Module", "Method", "Complexity"]
    end
  end

  describe "#rows" do
    it "returns formatted rows" do
      expect(formatter.rows).to eq(
        [
          ["\e[37mfoo.rb\e[0m", "\e[37mFoo\e[0m", "\e[37m13\e[0m"],
          ["\e[37mbar.rb\e[0m", "\e[37mBar\e[0m", "\e[37m11\e[0m"]
        ]
      )
    end
  end

end