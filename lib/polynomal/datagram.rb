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
          # TODO: Is there a more precise time that we can get?
          #
          # Such as:
          #   Process.get_clocktime(Process::CLOCK_MONOTONIC)
          #   -- or --
          #   Process.get_clocktime(Process::CLOCK_REALTIME)
          #
          # Questions about `Time.now`:
          #   - Does `Time.now` have drift/float?
          #     * Apparently it uses Process::CLOCK_MONOTONIC under
          #       the hood for *nix-based operating systems
          #   - Is it subject to NTP adjustments?
          timestamp: Time.now.utc.to_i,
          type: type,
          name: normalize_name(name),
          value: value
        }
      end
    end
  end
end
