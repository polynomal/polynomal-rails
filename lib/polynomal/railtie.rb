# frozen_string_literal: true

module Polynomal
  module Rails
    class Railtie < ::Rails::Railtie
      config.after_initialize do
        Polynomal.start_rails_instrumentation
      end
    end
  end
end
