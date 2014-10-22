require 'spec_helper'

describe Society::Node do

  let(:node) { Society::Node.new(
      name:     "Foo",
      address:  "./foo.rb",
      edges:    %w{Bar Bat}
    )
  }

  describe "#initialize" do
    it "assigns its name" do
      expect(node.name).to eq("Foo")
    end
    it "assigns its address" do
      expect(node.address).to eq("./foo.rb")
    end
    it "assigns its edges" do
      expect(node.edges).to eq(["Bar", "Bat"])
    end
  end

  describe "#edge_count" do
    it "returns a count of its edges" do
      expect(node.edge_count).to eq 2
    end
  end

end