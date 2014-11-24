require 'spec_helper'
require 'analyst'

describe Society::ObjectGraph do

  let(:graph) { Struct.new(:nodes, :edges)}
  let(:node) { Struct.new(:full_name) }
  let(:edge) { Struct.new(:from, :to) }

  let(:node_instance_1) { node.new("sample_node")}
  let(:node_instance_2) { node.new("other_node")}
  let(:edge_instance) { edge.new(node_instance_1, node_instance_2) }

  let(:graph) { Society::ObjectGraph.new(
      nodes: [node_instance_1, node_instance_2],
      edges: [edge_instance]
    )
  }

  describe "#initialize" do
    it "initializes its nodes" do
      expect(graph.nodes.first.full_name).to eq "sample_node"
    end
    it "initializes its edges"  do
      expect(graph.edges.first.to.full_name).to eq "other_node"
    end

  end

end