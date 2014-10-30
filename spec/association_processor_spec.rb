require 'spec_helper'

describe Society::AssociationProcessor do

  let(:parser)    { Society::Parser.new("./spec/fixtures") }
  let(:bar_class) { parser.analyzer.classes.detect{|c| c.name == "Bar"} }
  let(:foo_class) { parser.analyzer.classes.detect{|c| c.name == "Foo"} }

  describe "#associations" do

    context "associations of 'belongs_to :thing, class_name: \"Foo\"' type" do

      let(:processor) { Society::AssociationProcessor.new(bar_class) }

      it "recognizes the source" do
        expect(processor.associations.first.from).to eq "Bar"
      end

      it "recognizes the target" do
        expect(processor.associations.first.to).to eq "Foo"
      end

    end

    context "associations of 'has_many :things' type" do

      let(:processor) { Society::AssociationProcessor.new(foo_class) }

      it "recognizes the source" do
        expect(processor.associations.first.from).to eq "Foo"
      end

      it "recognizes the target" do
        expect(processor.associations.first.to).to eq "Bar"
      end

    end

  end

end
