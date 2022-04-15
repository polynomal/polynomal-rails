# frozen_string_literal: true

module Polynomal
  class Collector
    def initialize
      @ruby_collectors = []
      @rails_collectors = []

      register_ruby_collector(Polynomal::Instrumentation::GarbageCollection)

      # TODO: Disabled for now, needs fixing
      # register_rails_instrumentation(Polynomal::Instrumentation::ActiveRecord)
    end

    def start_ruby_collectors
      @ruby_collectors.each(&:start)
      true
    end

    def start_rails_collectors
      unless defined?(::Rails)
        Polynomal.logger.warn("Polynomal cannot start Rails instrumentation, Rails is not defined.")
        return
      end

      @rails_collectors.each(&:start)
      true
    end

    private

    def register_ruby_collector(instrumentation)
      @ruby_collectors << instrumentation
    end

    def register_rails_collector(instrumentation)
      @rails_collectors << instrumentation
    end
  end
end

require "polynomal/instrumentation/active_record"
require "polynomal/instrumentation/garbage_collection"
