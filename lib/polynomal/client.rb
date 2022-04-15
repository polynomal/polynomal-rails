# frozen_string_literal: true

require "forwardable"

module Polynomal
  # The Polynomal client contains all the methods for interacting with the
  # Polynomal service. It can be used to send notifications to multiple
  # projects in large apps. The global singleton instance ({Client.instance}) should
  # always be accessed through the {Polynomal} singleton.
  class Client
    extend Forwardable

    def_delegators :worker, :shutdown

    def self.instance
      @instance ||= new
    end

    def initialize(
      config: Polynomal.config,
      transmitter: Polynomal::Transmitter::HTTP.new(
        host: Polynomal.config.api.host,
        port: Polynomal.config.api.port,
        api_key: Polynomal.config.api.key
      )
    )
      @config = config
      @worker = Worker.new(
        config: config,
        transmitter: transmitter
      )
    end

    def count(name, value = 1)
      worker.push(Polynomal::Datagram.build(name, value, "count"))
    end

    def increment(name)
      worker.push(Polynomal::Datagram.build(name, 1, "increment"))
    end

    private

    attr_reader :config, :worker
  end
end

require "polynomal/worker"
require "polynomal/datagram"
require "polynomal/transmitter/http"
