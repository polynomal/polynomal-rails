# frozen_string_literal: true

module Polynomal
  class Config
    DEFAULTS = {
      host: "https://www.polynomal.com",
      port: 443,
      max_queue_size: 10_000,
      thread_sleep_duration: 0.5,
      flush_data_on_exit: false
    }

    attr_reader :max_queue_size,
      :thread_sleep_duration

    attr_accessor :api,
      :api_key,
      :application,
      :flush_data_on_exit,
      :logger

    def initialize
      @api = Api.new(host: DEFAULTS[:host], port: DEFAULTS[:port])
      @application = Application.new
      @max_queue_size = DEFAULTS[:max_queue_size]
      @thread_sleep_duration = DEFAULTS[:thread_sleep_duration]
      @flush_data_on_exit = DEFAULTS[:flush_data_on_exit]
      @logger = default_logger
    end

    def max_queue_size=(size)
      if (size = size.to_i) <= 0
        raise ArgumentError, "max_queue_size must be greater than 0"
      end
      @max_queue_size = size
    end

    def thread_sleep_duration=(duration)
      if (duration = duration.to_i) < 0
        raise ArgumentError, "thread_sleep_duration must not be negative"
      end
      @thread_sleep_duration = duration
    end

    private

    def default_logger
      Logger.new($stdout).tap do |l|
        l.formatter = Polynomal::Logger::Formatter::Pretty.new
      end
    end

    class Api
      attr_accessor :host, :port, :key

      def initialize(host:, port:, key: nil)
        @host = host
        @port = port
        @key = key
      end
    end

    class Application
      attr_accessor :name, :environment

      def initialize(name: inferred_name, environment: inferred_env)
        @name = name
        @environment = environment
      end

      def to_h
        @to_h ||= {
          name: name,
          environment: environment
        }
      end

      private

      def inferred_env
        ENV["RAILS_ENV"] || ENV["RUBY_ENV"] || ENV["RACK_ENV"]
      end

      def inferred_name
        if defined?(::Rails)
          if ::Rails.version < "6"
            ::Rails.application.class.parent_name.downcase
          else
            ::Rails.application.class.module_parent_name.downcase
          end
        else
          "Ruby"
        end
      end
    end
  end
end

require "polynomal/logger"
