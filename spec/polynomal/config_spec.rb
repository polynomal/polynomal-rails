# frozen_string_literal: true

require "spec_helper"

RSpec.describe Polynomal::Config do
  describe ".host" do
    it "should return the default host" do
      expect(Polynomal::Config.new.host).to eq(Polynomal::Config::DEFAULT_HOST)
    end
  end

  describe ".port" do
    it "should return the default port" do
      expect(Polynomal::Config.new.port).to eq(Polynomal::Config::DEFAULT_PORT)
    end
  end

  describe ".host=" do
    let(:instance) { described_class.new }
    let(:new_value) { "example.com" }
    before { instance.host = new_value }

    context "when the host is set to a non-default value" do
      it "should return the new value" do
        expect(instance.host).to eq(new_value)
      end
    end

    context "when the host is set to nil" do
      let(:new_value) { nil }

      it "should set the value to nil" do
        expect(instance.host).to eq(nil)
      end
    end
  end

  describe ".port=" do
    let(:instance) { described_class.new }
    let(:new_value) { 80 }
    before { instance.port = new_value }

    context "when the port is set to a non-default value" do
      it "should return the new value" do
        expect(instance.port).to eq(new_value)
      end
    end

    context "when the port is set to nil" do
      let(:new_value) { nil }

      it "should set the value to nil" do
        expect(instance.port).to eq(nil)
      end
    end
  end
end
