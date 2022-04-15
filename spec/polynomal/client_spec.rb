# frozen_string_literal: true

require "spec_helper"

RSpec.describe Polynomal::Client do
  describe ".instance" do
    it "should return the default client instance" do
      expect(described_class.instance).to be_an_instance_of(Polynomal::Client)
    end
  end

  describe ".new" do
    it "should return a new instance" do
      expect(described_class.new).to be_an_instance_of(Polynomal::Client)
    end
  end
end
