# frozen_string_literal: true

require "json"

module Polynomal
  class Client
    def self.default
      @default ||= new
    end

    MAX_SOCKET_AGE = 25
    MAX_QUEUE_SIZE = 10_000

    def initialize(
      transporter: Polynomal::Transporter::HTTP.new,
      max_queue_size: Polynomal.config.max_queue_size,
      thread_sleep_duration: Polynomal.config.thread_sleep_duration
    )
      @metrics = []
      @queue = Queue.new
      @max_queue_size = max_queue_size
      @transporter = transporter
      @worker_thread = nil
      @mutex = Mutex.new
      @thread_sleep_duration = thread_sleep_duration
      @json_serializer = JSON
    end
  end
end

require "polynomal/transporter/http"
