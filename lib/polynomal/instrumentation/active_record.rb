# frozen_string_literal: true

module Polynomal
  module Instrumentation
    class ActiveRecord
      def self.start(client: nil, frequency_in_sec: 30)
        unless defined?(::ActiveRecord)
          $stderr.puts("ActiveRecord is not defined, assuming it is not loaded")
          return
        end

        unless ::ActiveRecord::Base.connection_pool.respond_to?(:stat)
          $stderr.puts("ActiveRecord connection_pool.stat not supported in this rails version")
          return
        end

        active_record_collector = new
        client ||= Polynomal::Client.default

        stop if @thread

        @thread = Thread.new do
          loop do
            active_record_collector.collect.each { |metric| client.send(metric) }
          rescue => e
            $stderr.puts("Polynomal failed to collect process stats #{e}")
          ensure
            sleep(frequency_in_sec)
          end
        end
      end

      def self.stop
        if (thread = @thread)
          thread.kill
          @thread = nil
        end
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

          metric = {type: "active_record"}
          metric.merge!(pool.stat)
          accum << metric
        end
      end
    end
  end
end
