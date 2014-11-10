require 'spec_helper'

describe "Fukuzatsu::Formatters::HTML" do

  let (:method_summary_1) { Fukuzatsu::Summary.new(
      :source => "foo.rb",
      :entity => "::initialize",
      :container => "Foo",
      :summaries => []
    )
  }

  let (:method_summary_2) { Fukuzatsu::Summary.new(
      :source => "foo.rb",
      :entity => "#print",
      :container => "Foo",
      :summaries => []
    )
  }

  let (:summary) { Fukuzatsu::Summary.new(
      :source => "foo.rb",
      :entity => "Foo",
      :container => "Foo",
      :summaries => [method_summary_1, method_summary_2]
    )
  }

  let (:formatter) { Fukuzatsu::Formatters::Html.new(summary: summary) }

  describe "#header" do
    it "returns an HTML-formatted header" do
      expect(formatter.header).to eq(
        "<th>Class</th>\r\n<th>Method</th>\r\n<th>Complexity</th>"
      )
    end
  end

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

    it "returns HTML-formatted rows" do
      expected = "<tr class='even'>\r\n  <td>Foo</td>\r\n  <td>::initialize</td>\r\n  <td>13</td>\r\n</tr>\r\n"
      expected << "<tr class='odd'>\r\n  <td>Foo</td>\r\n  <td>#report</td>\r\n  <td>11</td>\r\n</tr>"
      expect(formatter.rows).to eq(expected)
    end
  end

  describe "#file_extension" do
    it "returns the proper extension" do
      expect(formatter.file_extension).to eq ".htm"
    end
  end

end
