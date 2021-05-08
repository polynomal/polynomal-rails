# frozen_string_literal: true

RSpec.describe Polynomal do
  describe ".configure" do
    context "when a block is given" do
      it "should yield the block to the Polynomal::Config instance" do
        expect { |b| Polynomal.configure(&b) }.to yield_with_args(Polynomal::Config)
      end
    end

    context "when no block is given" do
      it "should raise a LocalJumpError" do
        expect { Polynomal.configure }.to raise_error(LocalJumpError)
      end
    end
  end

  describe ".config" do
    it "should return a Polynomal::Config instance" do
      aggregate_failures do
        expect(Polynomal.config).to_not be(nil)
        expect(Polynomal.config).to be_an_instance_of(Polynomal::Config)
      end
    end
  end

  it "has a version number" do
    expect(Polynomal::VERSION).not_to be nil
  end
end
