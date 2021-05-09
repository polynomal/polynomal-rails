# frozen_string_literal: true

module Polynomal
  ##
  # Configuration for Polynomal, use like:
  #
  #   Polynomal.configure do |config|
  #     config.host = "https://www.example.com"
  #     config.port = "443"
  #   end
  def self.configure
    yield config
  end

  def self.config
    @config ||= Polynomal::Config.new
  end
end

require "polynomal/config"
require "polynomal/client"
require "polynomal/instrumentation"
require "polynomal/version"
