# frozen_string_literal: true

require "spec_helper"

RSpec.describe Polynomal::Transporter::HTTP do
  describe "#new" do
    it "should return a valid instance" do
      expect(described_class.new).to be_an_instance_of(Polynomal::Transporter::HTTP)
    end
  end
end
