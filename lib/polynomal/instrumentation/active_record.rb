# frozen_string_literal: true

module Polynomal
  module Instrumentation
    class ActiveRecord
      def self.start(client: nil, frequency: 30)
        unless ::ActiveRecord::Base.connection_pool.respond_to?(:stat)
          $stderr.warn("ActiveRecord connection_pool.stat not supported in this rails version")
          return
        end

        active_record_collector = new
        client ||= Polynomal::Client.default

        stop if @thread

        @thread = Thread.new do
          loop do
            metrics = active_record_collector.collect
            metrics.each { |metric| client.send_json(metric) }
          rescue => e
            $stderr.warn("Polynomal failed to collect process stats #{e}")
          ensure
            sleep(frequency)
          end
        end
      end

      def self.stop
        if (thread = @thread)
          thread.kill
          @thread = nil
        end
      end

      def initialize
      end

      def collect
        metrics = []
        collect_active_record_pool_stats(metrics)
        metrics
      end

      def pid
        @pid = ::Process.pid
      end

      def collect_active_record_pool_stats(accum)
        ObjectSpace.each_object(::ActiveRecord::ConnectionAdapters::ConnectionPool) do |pool|
          next if pool.connections.nil?

          metric = {
            pid: pid,
            type: "active_record"
            # hostname: ::Polynomal.config.hostname,
            # metric_labels: labels(pool)
          }
          metric.merge!(pool.stat)
          accum << metric
        end
      end
    end
  end
end
