require 'spec_helper'
require_relative 'fixtures/clustering/clusterer_fixtures.rb'

describe Society::Clusterer do

  describe "#cluster" do
    let(:clusterer) { Society::Clusterer.new }

    it "detects clusters" do
      clusters = clusterer.cluster(MCL::GRAPH_1).map(&:sort)
      expected = MCL::CLUSTERS_1.map(&:sort)
      expect(clusters).to match_array(expected)
    end

    context "with inflation parameter set to 1.7" do
      let(:clusterer) { Society::Clusterer.new(inflation: 1.7) }

      it "detects clusters at coarser granularity" do
        clusters = clusterer.cluster(MCL::GRAPH_1).map(&:sort)
        expected = MCL::CLUSTERS_1_I17.map(&:sort)
        expect(clusters).to match_array(expected)
      end
    end

    context "with inflation parameter set to 4.0" do
      let(:clusterer) { Society::Clusterer.new(inflation: 4.0) }

      it "detects clusters at finer granularity" do
        clusters = clusterer.cluster(MCL::GRAPH_1).map(&:sort)
        expected = MCL::CLUSTERS_1_I40.map(&:sort)
        expect(clusters).to match_array(expected)
      end
    end
  end

end

