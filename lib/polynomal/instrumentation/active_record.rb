# frozen_string_literal: true

module Polynomal
  module Instrumentation
    class ActiveRecord
      @thread = nil unless defined?(@thread)

      class << self
        def start(client: nil, frequency_in_sec: 5)
          client ||= Polynomal::Client.instance

          unless defined?(::ActiveRecord)
            Polynomal.logger.info("ActiveRecord is not defined, assuming it is not loaded")
            return
          end

          unless ::ActiveRecord::Base.connection_pool.respond_to?(:stat)
            Polynomal.logger.warn("ActiveRecord connection_pool.stat not supported in this rails version")
            return
          end

          collector = new

          kill_existing_thread if @thread

          @thread = Thread.new do
            loop do
              collector.collect.each { |metric| client.send(metric) }
            rescue => e
              $stderr.puts("failed to collect process stats: #{e}")
            ensure
              sleep(frequency_in_sec)
            end
          end
        end

        def kill_existing_thread
          if (thread = @thread)
            thread.kill
            @thread = nil
          end
        end
      end

      def collect
        metrics = []
        collect_active_record_pool_stats(metrics)
        metrics
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
