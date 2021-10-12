# frozen_string_literal: true

module Polynomal
  class InstrumentationMediator
    def initialize
      @ruby_instrumentation = []
      @rails_instrumentation = []

      register_ruby_instrumentation(Polynomal::Instrumentation::GarbageCollection)

      # TODO: Disabled for now, needs fixing
      # register_rails_instrumentation(Polynomal::Instrumentation::ActiveRecord)
    end

    def start_ruby_instrumentation
      @ruby_instrumentation.map(&:start)
      true
    end

    def start_rails_instrumentation
      unless defined?(::Rails)
        $stderr.puts("Polynomal cannot start Rails instrumentation, Rails is not defined.")
        return
      end

      @rails_instrumentation.map(&:start)
      true
    end

    private

    def register_ruby_instrumentation(instrumentation)
      @ruby_instrumentation << instrumentation
    end

    def register_rails_instrumentation(instrumentation)
      @rails_instrumentation << instrumentation
    end
  end
end

require "polynomal/instrumentation/active_record"
require "polynomal/instrumentation/garbage_collection"
