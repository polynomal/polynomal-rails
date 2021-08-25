# frozen_string_literal: true

module Polynomal
  class Datagram
    class << self
      def build(name, value, type)
        generate_generic_datagram(name, value, type)
      end

      protected

      def normalize_name(name)
        return name unless /[:|@]/.match?(name)
        name.tr(":|@", "")
      end

      def generate_generic_datagram(name, value, type)
        {
          timestamp: Time.now.utc.to_i,
          type: type,
          name: normalize_name(name),
          value: value
        }
      end
    end
  end
end
