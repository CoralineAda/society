require 'spec_helper'

describe Society::ObjectGraph do

  context "nodes" do

    let(:graph) { Society::Graph.new }
    let(:node)  { Struct.new(:name) }
    let(:sample_node) { node.new("sample") }

    it "collects nodes" do
      graph.nodes << sample_node
      expect(graph.nodes.include?(sample_node)).to be_truthy
    end

  end

end