require 'spec_helper'

describe Society::ReferenceProcessor do

  describe "#references" do

    let(:proxy)     { Struct.new(:name, :full_name, :constants, :constant_assignments) }
    let(:avatar_1)  { proxy.new("AnimalMan", "Red::AnimalMan", [], []) }
    let(:avatar_2)  { proxy.new("Arcane", "Rot::Arcane", [], []) }
    let(:avatar_3)  { proxy.new("SwampThing", "Green::SwampThing", [avatar_1, avatar_2], []) }
    let(:processor) { Society::ReferenceProcessor.new([avatar_1, avatar_2, avatar_3]) }

    it "returns referenced classes" do
      expect(processor.references.map(&:to)).to eq([avatar_1, avatar_2])
    end
  end
end

