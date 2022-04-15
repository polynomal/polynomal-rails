# frozen_string_literal: true

require "forwardable"

module Polynomal
  class Worker
    extend Forwardable

    # Subclassed thread so we have a named thread for debugging
    class Thread < ::Thread; end

    # Subclassed error so we have a named error for shuting down
    class ShutdownWorker < ::StandardError; end

    SHUTDOWN = :__pn_worker_shutdown!

    def initialize(config:, transmitter:)
      @config = config
      @transmitter = transmitter
      @mutex = Mutex.new
      @queue = Queue.new
      @shutdown = false
      @pid = Process.pid
    end

    def push(msg)
      return false unless start

      if queue.size >= config.max_queue_size
        logger.warn("unable to report metric, max queue size reached. Dropping first item in queue")
        return false
      end

      queue.push(msg)
    end

    def start
      return false unless can_start?

      mutex.synchronize do
        @shutdown = false

        return true if thread&.alive?

        @pid = Process.pid
        @thread = Thread.new { process_queue }
      end

      true
    end

    def shutdown(force: false)
      logger.debug("shutting down worker")

      mutex.synchronize do
        @shutdown = true
      end

      return true if force
      return true unless thread&.alive?

      unless queue.empty?
        logger.info("waiting to report metric(s) to Polynomal")
      end

      queue.push(SHUTDOWN)
      !!thread.join
    ensure
      queue.clear
      kill!
    end

    private

    attr_reader :config,
      :transmitter,
      :mutex,
      :thread,
      :queue,
      :started_at,
      :pid

    def_delegator :config, :logger

    def shutdown?
      mutex.synchronize { @shutdown }
    end

    def can_start?
      return false if shutdown?
      true
    end

    def kill!
      logger.debug("killing worker thread")

      if thread
        Thread.kill(thread)
        thread.join
      end

      true
    end

    def process_queue
      begin
        logger.debug("worker started")
        loop do
          flush_queue_until_empty
          sleep(config.thread_sleep_duration)
        rescue ShutdownWorker
          break
        end
      ensure
        logger.debug("stopping worker")
      end
    rescue => e
      logger.error("error in worker thread, shutting down. error: #{e}")
    end

    def flush_queue_until_empty
      while queue.length > 0
        case msg = queue.pop
        when SHUTDOWN then raise ShutdownWorker
        else transmit(msg)
        end
      end
    end

    def transmit(payload)
      transmitter.transmit(:metric, payload)
    rescue => e
      logger.warn("failed to send a metric: #{e}")
    end
  end
end
