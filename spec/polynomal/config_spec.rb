# frozen_string_literal: true

require "spec_helper"

RSpec.describe Polynomal::Config do
  let(:config) { Polynomal::Config.new }

  describe ".api" do
    it { expect(config.api).to be_an_instance_of(Polynomal::Config::Api) }

    describe ".host" do
      context "when using the default host" do
        it { expect(config.api.host).to eq(Polynomal::Config::DEFAULTS[:host]) }
      end

      context "when using a non-default host" do
        before { config.api.host = "foobar.example.com" }

        it { expect(config.api.host).to eq("foobar.example.com") }
      end
    end

    describe ".host=" do
      before { config.api.host = "foobar.example.com" }

      it "should set and return the new value" do
        expect(config.api.host).to eq("foobar.example.com")
      end
    end

    describe ".port" do
      context "when using the default host" do
        it { expect(config.api.port).to eq(Polynomal::Config::DEFAULTS[:port]) }
      end

      context "when using a non-default port" do
        before { config.api.port = 8080 }

        it { expect(config.api.port).to eq(8080) }
      end
    end

    describe ".port=" do
      before { config.api.port = 8080 }

      it "should set and return the new value" do
        expect(config.api.port).to eq(8080)
      end
    end

    describe ".key" do
      context "when using the default api_key" do
        it { expect(config.api.key).to eq(nil) }
      end

      context "when using a non-default api_key" do
        before { config.api.key = "secret_api_key" }

        it { expect(config.api.key).to eq("secret_api_key") }
      end
    end

    describe ".api_key=" do
      before { config.api.key = "secret_api_key" }

      it "should set and return the new value" do
        expect(config.api.key).to eq("secret_api_key")
      end
    end
  end
end
