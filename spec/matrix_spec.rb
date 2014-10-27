require 'spec_helper'

describe Society::Matrix do

  let(:node)   { Struct.new(:name, :edges) }
  let(:nodes)  {
    [
      node.new("foo", %w{bar bat baz}),
      node.new("bar", %w{foo bat baz})
    ]
  }
  let(:matrix) { Society::Matrix.new(nodes) }

  describe "#initialize" do
    it "assigns its nodes" do
      expect(matrix.nodes).to eq(nodes)
    end
  end

  describe "#to_json" do
    it "generates a json representation" do
      expected = {
        "nodes"=>[
          {"name"=>"foo", "group"=>1},
          {"name"=>"bar", "group"=>1}
        ],
        "links"=>[
          {"source"=>0, "target"=>1, "value"=>1},
          {"source"=>1, "target"=>0, "value"=>1}
        ]
      }.to_json
      expect(matrix.to_json).to eq(expected)
    end
  end

end