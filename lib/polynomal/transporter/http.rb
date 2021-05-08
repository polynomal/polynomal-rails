# frozen_string_literal: true

module Polynomal
  module Transporter
    class HTTP
      def initialize(config: Polynomal.config)
        @host = config.host
        @port = config.port
      end
    end
  end
end
