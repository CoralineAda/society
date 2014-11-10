require 'spec_helper'

describe Fukuzatsu::Formatters::Csv do

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

  let (:formatter) { Fukuzatsu::Formatters::Csv.new(summary: summary) }

  describe "#rows" do

    before do
      allow(summary).to receive(:container_name).and_return("Foo")
      allow(summary).to receive(:entity_name).and_return("*")
      allow(summary).to receive(:complexity).and_return(13)
      allow(summary).to receive(:averge_complexity).and_return(11)
      allow(method_summary_1).to receive(:container_name).and_return("Foo")
      allow(method_summary_1).to receive(:entity_name).and_return("::initialize")
      allow(method_summary_1).to receive(:complexity).and_return(13)
      allow(method_summary_2).to receive(:container_name).and_return("Foo")
      allow(method_summary_2).to receive(:entity_name).and_return("#report")
      allow(method_summary_2).to receive(:complexity).and_return(11)
    end

    it "returns formatted rows" do
      expect(formatter.rows).to eq(
        [
          ["foo.rb","Foo","::initialize",13].join(","),
          ["foo.rb","Foo","#report",11].join(","),
        ].join("\r\n")
      )
    end
  end

end