require 'spec_helper'
require 'analyst'

describe Society::Node do

  let(:edge)   { Struct.new(:to, :weight) { def +(_) self end } }
  let(:edge_a) { edge.new("A", 1) }
  let(:edge_b) { edge.new("B", 1) }

  describe "#initialize" do

    it "returns a node object" do
      node = Society::Node.new(name: "A", type: :class)
      expect(node.class.name).to eq("Society::Node")
    end

    it "initializes its edges" do
      node = Society::Node.new(name: "A", type: :class, edges: [edge_a, edge_b])
      expect(node.edges.first).to eq(edge.new("A", 1))
    end

    it "initializes metainformation" do
      node = Society::Node.new(name: "A", type: :class, meta: [true])
      expect(node.meta).to match_array [true]
    end

  end

  describe "#intersects?" do
    let(:node)              { Society::Node.new(name: "A", type: :class) }
    let(:nonintersecting_a) { Society::Node.new(name: "A", type: :module) }
    let(:nonintersecting_b) { Society::Node.new(name: "B", type: :class) }
    let(:intersecting)      { Society::Node.new(name: "A", type: :class) }

    it "detects intersections iff name and type are the same" do
      expect(node.intersects?(nonintersecting_a)).to eq(false)
      expect(node.intersects?(nonintersecting_b)).to eq(false)
      expect(node.intersects?(intersecting)).to eq(true)
    end

  end

  describe "#+" do
    let(:node_a) { Society::Node.new(name: "A", type: :class, edges: [edge_a]) }
    let(:node_b) { Society::Node.new(name: "A", type: :class, edges: [edge_b]) }
    let(:node_c) { Society::Node.new(name: "A", type: :class, unresolved: [edge_b]) }

    it "allows addition of intersecting nodes, accumulating edges" do
      node_d = node_a + node_b
      expect(node_d.edges.sort_by(&:to)).to eq([edge_a, edge_b])

      node_e = node_a + node_c
      expect(node_e.edges).to eq([edge_a])
      expect(node_e.unresolved).to eq([edge_b])
    end

    it "treats addition against itself as a no-op" do
      node_d = node_a + node_a
      expect(node_d.object_id).to eq(node_a.object_id)
    end

  end

  describe "#to_s" do
    let(:node_a) { Society::Node.new(name: "A", type: :class, edges: [edge_a]) }

    it "returns the node's name as a string" do
      expect(node_a.to_s).to eq("A")
    end
  end

end

describe Society::Edge do

  describe "#initialize" do
    it "returns an edge object" do
      expect(Society::Edge.new(to: "A").class.name).to eq("Society::Edge")
    end

    it "uses a default weight of 1 for an edge" do
      expect(Society::Edge.new(to: "A").weight).to eq(1)
    end

    it "allows a weight to be specified" do
      expect(Society::Edge.new(to: "A", weight: 3).weight).to eq(3)
    end
  end

  describe "#+" do
    let(:edge_a1) { Society::Edge.new(to: "A", weight: 1) }
    let(:edge_a2) { Society::Edge.new(to: "A", weight: 2) }
    let(:edge_b)  { Society::Edge.new(to: "B") }

    it "adds the weights of two like edges" do
      edge_a3 = edge_a1 + edge_a2
      expect(edge_a3.weight).to eq(3)
    end

    it "returns nil if the edge targets are not aligned" do
      edge_z = edge_a1 + edge_b
      expect(edge_z).to eq(nil)
    end

  end

  describe "#+" do
    let(:edge) { Society::Edge.new(to: "A", weight: 1) }

    it "returns the name of the target node as a string" do
      expect(edge.to_s).to eq("A")
    end

  end

end

describe Society::ObjectGraph do

  let(:edge_a) { Society::Edge.new(to: "A") }
  let(:edge_b) { Society::Edge.new(to: "B") }
  let(:edge_d) { Society::Edge.new(to: "D") }

  let(:node_a) { Society::Node.new(name: "A", type: :class, edges: [edge_b]) }
  let(:node_b) { Society::Node.new(name: "B", type: :class, edges: [edge_d]) }
  let(:node_c) { Society::Node.new(name: "C", type: :class, edges: [edge_d]) }
  let(:node_d) { Society::Node.new(name: "D", type: :class, edges: [edge_a, edge_b]) }

  describe "#initialize" do

    it "returns an ObjectGraph object" do
      expect(Society::ObjectGraph.new.class.name).to eq("Society::ObjectGraph")
    end

    it "is empty by default" do
      expect(Society::ObjectGraph.new).to eq([])
    end

    it "allows several nodes to be given" do
      expect(Society::ObjectGraph.new(node_a, node_b).first).to eq(node_a)
    end

    it "allows a list of nodes to be given" do
      expect(Society::ObjectGraph.new([node_a, node_b]).first).to eq(node_a)
    end

  end

  describe "#+" do

    let(:node_a2) { Society::Node.new(name: "A", type: :class, edges: [edge_b, edge_d]) }

    let(:graph_a) { Society::ObjectGraph.new([node_a]) }
    let(:graph_b) { Society::ObjectGraph.new([node_b]) }
    let(:graph_c) { Society::ObjectGraph.new([node_a2, node_c, node_d]) }

    it "treats addition of an empty graph as a no-op" do
      expect(graph_a + Society::ObjectGraph.new).to eq(graph_a)
    end

    it "does not modify nodes when none intersect" do
      expect(graph_a + graph_b).to eq([node_a, node_b])
    end

    it "sums nodes which intersect" do
      graph_d = graph_a + graph_c
      node = graph_d.select { |node| node.name == "A" }.first

      expect(graph_d.length).to eq(3)
      expect(node.edges.select { |n| n.to == "B" }.first.weight ).to eq(2)
    end

  end

  describe "#<<" do

    let(:node_a2) { Society::Node.new(name: "A", type: :class, edges: [edge_b, edge_d]) }
    let(:graph_a) { Society::ObjectGraph.new([node_a]) }

    it "returns a new graph object without mutating the original" do
      graph_b = graph_a << node_b
      expect(graph_a.length).to eq(1)
      expect(graph_b.object_id).not_to eq(graph_a.object_id)
    end

    it "sums nodes which intersect" do
      graph_b = graph_a << node_a2
      node = graph_b.select { |node| node.name == "A" }.first
      expect(node.edges.select { |n| n.to == "B" }.first.weight ).to eq(2)
    end

  end

  describe "#to_h" do

    let(:graph_a) { Society::ObjectGraph.new([node_a]) }

    it "returns a hash representing the graph" do
      expect(graph_a.to_h).to eq({node_a.name => node_a.edges})
    end

  end

  describe "#to_json" do

    let(:graph_a) { Society::ObjectGraph.new([node_a]) }

    it "returns a json string representing the graph" do
      expect(graph_a.to_json).to eq('{"A":{"B":1}}')
    end

  end

end
