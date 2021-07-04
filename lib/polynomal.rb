# frozen_string_literal: true

module Polynomal
  class << self
    ##
    # Configuration for Polynomal, use like:
    #
    #   Polynomal.configure do |config|
    #     config.host = "https://www.example.com"
    #     config.port = 443
    #     config.max_queue_size = 100
    #   end
    def configure
      yield config
    end

    def config
      @config ||= Polynomal::Config.new
    end

    def client
      @client ||= Polynomal::Client.default
    end

    def start_ruby_instrumentation
      instrumentation_mediator.start_ruby_instrumentation
    end

    def start_rails_instrumentation!
      instrumentation_mediator.start_rails_instrumentation
    end

    def count(name, value = 1)
      datagram = Polynomal::Datagram.build(name, value, "count")
      client.send(datagram)
    end

    def increment(name, value = 1)
      datagram = Polynomal::Datagram.build(name, value, "increment")
      client.send(datagram)
    end

    private

    def instrumentation_mediator
      @collector ||= Polynomal::InstrumentationMediator.new
    end
  end
end

require "polynomal/config"
require "polynomal/client"
require "polynomal/datagram"
require "polynomal/instrumentation_mediator"
require "polynomal/railtie" if defined?(Rails)
require "polynomal/version"
