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

  describe ".client" do
    it "should return an instance of Polynomal::Client" do
      expect(Polynomal.client).to be_an_instance_of(Polynomal::Client)
    end
  end

  describe ".start_ruby_collectors" do
    let(:collector) { instance_double("Polynomal::Collector") }

    before do
      allow(Polynomal::Collector).to receive(:new).and_return(collector)
    end

    it "should delegate to the Polynomal::Collector instance" do
      expect(Polynomal.send(:collector)).to receive(:start_ruby_collectors)
      Polynomal.start_ruby_collectors
    end
  end

  describe ".start_rails_collectors" do
    let(:collector) { instance_double("Polynomal::Collector") }

    before do
      allow(Polynomal::Collector).to receive(:new).and_return(collector)
    end

    it "should delegate to the Polynomal::InstrumentationMediator instance" do
      expect(Polynomal.send(:collector)).to receive(:start_rails_collectors)
      Polynomal.start_rails_collectors
    end
  end

  it "has a version number" do
    expect(Polynomal::VERSION).not_to be nil
  end
end
