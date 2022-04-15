# frozen_string_literal: true

require "forwardable"

require "polynomal/config"
require "polynomal/client"
require "polynomal/collector"
require "polynomal/version"

module Polynomal
  class << self
    extend Forwardable

    def_delegators :client,
      :count,
      :increment

    def_delegators :collector,
      :start_ruby_collectors,
      :start_rails_collectors

    def_delegators :config,
      :logger

    def configure
      yield config
    end

    def config
      @config ||= Polynomal::Config.new
    end

    def client
      @client ||= Polynomal::Client.instance
    end

    def install_at_exit_callback
      return unless config.flush_data_on_exit

      at_exit do
        Polynomal.stop
      end
    end

    def stop(force: false)
      client.shutdown(force: force)
      true
    end

    protected

    def collector
      @collector ||= Polynomal::Collector.new
    end
  end
end

Polynomal.install_at_exit_callback

require "polynomal/initializer/rails" if defined?(::Rails::Railtie)
require "polynomal/initializer/ruby"
