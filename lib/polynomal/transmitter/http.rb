# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module Polynomal
  module Transmitter
    class HTTP
      attr_reader :host, :port, :api_key

      ENDPOINTS = {
        metric: "/api/v1/metrics"
      }

      def initialize(api_key:, host:, port: nil)
        @host = host
        @port = port || uri.port
        @api_key = api_key
      end

      def transmit(feature, payload)
        http_client.request(
          post(
            endpoint: ENDPOINTS[feature.to_sym],
            payload: payload
          )
        )
      end

      private

      def post(endpoint:, payload:)
        Net::HTTP::Post.new(endpoint).tap do |request|
          request.body = JSON.dump(payload)
          request["Content-Type"] = "application/json"
          request["Authorization"] = bearer_token_with_api_key
        end
      end

      def http_client
        Net::HTTP.new(uri.host, port).tap do |conn|
          conn.use_ssl = true if uri.instance_of?(URI::HTTPS)
        end
      end

      def uri
        URI.parse(host)
      end

      def bearer_token_with_api_key
        "Bearer #{api_key}"
      end
    end
  end
end
