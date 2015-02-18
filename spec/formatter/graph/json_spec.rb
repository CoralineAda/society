require 'spec_helper'
require 'analyst'

describe Society::Formatter::Graph::JSON do

  let(:graph) { Struct.new(:nodes, :edges)}
  let(:node) { Struct.new(:full_name) }
  let(:edge) { Struct.new(:from, :to) }

  let(:node_instance_1) { node.new("sample_node")}
  let(:node_instance_2) { node.new("other_node")}
  let(:edge_instance) { edge.new(node_instance_1, node_instance_2) }

  let(:graph_instance) { graph.new(
      [node_instance_1, node_instance_2],
      [edge_instance]
    )
  }

  let(:formatter) { Society::Formatter::Graph::JSON.new(graph_instance) }

  describe "#to_hash" do

    let(:hash) { formatter.to_hash }

    context "returns a hash" do
      it "with properly formatted nodes" do
        expect(hash[:nodes]).to eq(
          [
            {name: "sample_node", relations: ["other_node"]},
            {name: "other_node",  relations: []}
          ]
        )
      end
    end
  end

  describe "#to_json" do

    let(:json) { formatter.to_json }
    let(:hash) { formatter.to_hash }

    it "returns json string for the result of #to_hash" do
      expect(json).to eq hash.to_json
    end
  end
end

