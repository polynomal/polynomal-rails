# frozen_string_literal: true

module Polynomal
  module Initializer
    module Rails
      class Railtie < ::Rails::Railtie
        config.after_initialize do
          Polynomal.start_rails_collectors
        end
      end
    end
  end
end
