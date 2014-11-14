require 'spec_helper'

describe "Edge" do

  let(:edge_1) { Edge.new(from: 'here', 'eternity') }
  let(:edge_2) { Edge.new(from: 'here', 'there') }
  let(:edge_3) { Edge.new(from: 'onset', 'eternity') }
  let(:edge_4) { Edge.new(from: 'onset', 'eternity') }
  let(:graph)  { ObjectGraph.new }

  before do
    graph.edges = [edge_1, edge_2, edge_3, edge_4]
  end

  it "clusters edges" do
    graph.edges.about("eternity")
  end

end