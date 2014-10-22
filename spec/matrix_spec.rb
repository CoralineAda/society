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
      expected = "{\"names\":[\"foo\",\"bar\"],\"matrix\":[[],[0,1],[1,0]]}"
      expect(matrix.to_json).to eq(expected)
    end
  end

end