# frozen_string_literal: true

module Polynomal
  class Config
    DEFAULT_HOST = "https://www.polynomal.com/api"
    DEFAULT_PORT = 443
    DEFAULT_MAX_QUEUE_SIZE = 10_000
    DEFAULT_THREAD_SLEEP_DURATION = 0.5

    attr_reader :max_queue_size

    attr_accessor :api, :thread_sleep_duration, :api_key, :application

    def initialize
      @max_queue_size = DEFAULT_MAX_QUEUE_SIZE
      @thread_sleep_duration = DEFAULT_THREAD_SLEEP_DURATION
      @api = Api.new(host: DEFAULT_HOST, port: DEFAULT_PORT)
      @application = Application.new
    end

    def max_queue_size=(size)
      if size.to_i <= 0
        raise ArgumentError, "max_queue_size must be larger than 0"
      end

      @max_queue_size = size ? size.to_i : DEFAULT_MAX_QUEUE_SIZE
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

      def initialize(name: nil, environment: nil)
        @name = name
        @environment = environment
      end

      def valid?
        !(name.nil? || name.empty?) && !(environment.nil? || environment.empty?)
      end

      def to_h
        @to_h ||= {
          name: name,
          environment: environment
        }
      end
    end
  end
end
