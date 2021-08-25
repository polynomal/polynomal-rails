# frozen_string_literal: true

module Polynomal
  module Instrumentation
    class GarbageCollection
      @thread = nil unless defined?(@thread)

      def self.start(client: nil, frequency_in_sec: 5)
        process_collector = new

        stop if @thread

        @thread = Thread.new do
          loop do
            process_collector.collect
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
        collect_gc_stats
        nil
      end

      def pid
        @pid = ::Process.pid
      end

      def collect_gc_stats
        stat = GC.stat
        Polynomal.count("gc.heap_live_slots", stat[:heap_live_slots])
        Polynomal.count("gc.heap_free_slots", stat[:heap_free_slots])
        Polynomal.count("gc.major_gc_ops_total", stat[:major_gc_count])
        Polynomal.count("gc.minor_gc_ops_total", stat[:minor_gc_count])
        Polynomal.count("gc.allocated_objects_total", stat[:total_allocated_objects])
      end
    end
  end
end
