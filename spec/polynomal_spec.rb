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

  describe ".start_ruby_instrumentation!" do
    let(:instrumentation_mediator) { instance_double("InstrumentationMediator") }

    before do
      allow(Polynomal::InstrumentationMediator)
        .to receive(:new)
        .and_return(instrumentation_mediator)
    end

    after do
      Polynomal.instance_variable_set("@collector", nil)
    end

    it "should delegate to the Polynomal::InstrumentationMediator instance" do
      expect(instrumentation_mediator).to receive(:start_ruby_instrumentation)
      Polynomal.start_ruby_instrumentation!
    end
  end

  describe ".start_rails_instrumentation!" do
    let(:instrumentation_mediator) { instance_double("InstrumentationMediator") }

    before do
      allow(Polynomal::InstrumentationMediator)
        .to receive(:new)
        .and_return(instrumentation_mediator)
    end

    after do
      Polynomal.instance_variable_set("@collector", nil)
    end

    it "should delegate to the Polynomal::InstrumentationMediator instance" do
      expect(instrumentation_mediator).to receive(:start_ruby_instrumentation)
      Polynomal.start_ruby_instrumentation!
    end
  end

  it "has a version number" do
    expect(Polynomal::VERSION).not_to be nil
  end
end
