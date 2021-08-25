# frozen_string_literal: true

require "json"

module Polynomal
  class Client
    def self.default
      @default ||= new
    end

    def initialize(
      transporter: Polynomal::Transporter::HTTP.new,
      max_queue_size: Polynomal.config.max_queue_size,
      thread_sleep_duration: Polynomal.config.thread_sleep_duration
    )
      @queue = Queue.new
      @max_queue_size = max_queue_size
      @transporter = transporter
      @worker_thread = nil
      @mutex = Mutex.new
      @thread_sleep_duration = thread_sleep_duration
    end

    def send(obj)
      @queue << obj

      if @queue.length > @max_queue_size
        $stderr.puts("Polynomal::Client is dropping a message due to a full queue")
        @queue.pop
      end

      ensure_worker_thread!
    end

    def process_queue
      while @queue.length > 0
        begin
          message = {
            application: Polynomal.config.application.to_h,
            metric: @queue.pop
          }
          @transporter.transport(message)
        rescue => e
          $stderr.puts("Polynomal is dropping a message: #{e}")
          raise
        end
      end
    end

    private

    def worker_loop
      process_queue
    rescue => e
      $stderr.puts("Polynomal failed to send a message: #{e}")
    end

    def ensure_worker_thread!
      unless @worker_thread&.alive?
        @mutex.synchronize do
          return if @worker_thread&.alive?

          @worker_thread = Thread.new do
            loop do
              worker_loop
              sleep(@thread_sleep_duration)
            end
          end
        end
      end
    rescue ThreadError => e
      raise unless e.message.match?(/can't alloc thread/)
      $stderr.puts("Polynomal failed to send a message. ThreadError: #{e}")
    end
  end
end

require "polynomal/transporter/http"
