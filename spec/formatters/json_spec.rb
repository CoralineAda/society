require 'spec_helper'

describe "Fukuzatsu::Formatters::Json" do

  let (:method_summary_1) { Fukuzatsu::Summary.new(
      :source => "",
      :source_file => "foo.rb",
      :entity => "::initialize",
      :container => "Foo",
      :summaries => []
    )
  }

  let (:method_summary_2) { Fukuzatsu::Summary.new(
      :source => "",
      :source_file => "foo.rb",
      :entity => "#print",
      :container => "Foo",
      :summaries => []
    )
  }

  let (:summary) { Fukuzatsu::Summary.new(
      :source => "",
      :source_file => "foo.rb",
      :entity => "Foo",
      :container => "Foo",
      :summaries => [method_summary_1, method_summary_2]
    )
  }

  let (:formatter) { Fukuzatsu::Formatters::Json.new(summary: summary) }

  describe "#to_json" do

    before do
      allow(summary).to receive(:container_name).and_return("Foo")
      allow(summary).to receive(:entity_name).and_return("*")
      allow(summary).to receive(:complexity).and_return(13)
      allow(summary).to receive(:average_complexity).and_return(11)
      allow(method_summary_1).to receive(:container_name).and_return("Foo")
      allow(method_summary_1).to receive(:entity_name).and_return("::initialize")
      allow(method_summary_1).to receive(:complexity).and_return(13)
      allow(method_summary_2).to receive(:container_name).and_return("Foo")
      allow(method_summary_2).to receive(:entity_name).and_return("#print")
      allow(method_summary_2).to receive(:complexity).and_return(11)
    end

    it "returns JSON" do
      expected = {
        source_file: "foo.rb",
        object: "Foo",
        name: "*",
        complexity: 13,
        average_complexity: 11,
        methods: [
          {
            source_file: "foo.rb",
            object: "Foo",
            name: "::initialize",
            complexity: 13
          },
          {
            source_file: "foo.rb",
            object: "Foo",
            name: "#print",
            complexity: 11
          },
        ]
      }.to_json
      expect(formatter.content).to eq(expected)
    end
  end

  describe "#file_extension" do
    it "returns the proper extension" do
      expect(formatter.file_extension).to eq ".json"
    end
  end

end
