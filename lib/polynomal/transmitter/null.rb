# frozen_string_literal: true

module Polynomal
  module Transmitter
    class Null
      def transmit(feature, payload)
        nil
      end
    end
  end
end
