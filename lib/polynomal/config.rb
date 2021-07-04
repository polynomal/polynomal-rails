# frozen_string_literal: true

require "socket"

module Polynomal
  class Config
    DEFAULT_HOST = "https://www.polynomal.com/api"
    DEFAULT_PORT = 443
    DEFAULT_MAX_QUEUE_SIZE = 10_000
    DEFAULT_THREAD_SLEEP_DURATION = 0.5

    attr_reader :max_queue_size
    attr_accessor :host, :port, :thread_sleep_duration

    def initialize
      @host = DEFAULT_HOST
      @port = DEFAULT_PORT
      @max_queue_size = DEFAULT_MAX_QUEUE_SIZE
      @thread_sleep_duration = DEFAULT_THREAD_SLEEP_DURATION
    end

    def max_queue_size=(size)
      if size.to_i <= 0
        raise ArgumentError, "max_queue_size must be larger than 0"
      end

      @max_queue_size = size ? size.to_i : DEFAULT_MAX_QUEUE_SIZE
    end

    def hostname
      @hostname ||=
        begin
          Socket.gethostname
        rescue => e
          $stderr.puts("Unable to lookup hostname: #{e}")
          "unknown-host"
        end
    end
  end
end
