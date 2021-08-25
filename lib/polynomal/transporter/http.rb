# frozen_string_literal: true

require "net/http"
require "uri"

module Polynomal
  module Transporter
    class HTTP
      def initialize(host: Polynomal.config.api.host, port: Polynomal.config.api.port)
        @host = host
        @port = port
      end

      def transport(payload)
        http_client.request(post(payload))
      end

      private

      def post(payload)
        Net::HTTP::Post.new(uri.request_uri).tap do |request|
          request.body = payload.to_json
          request["Content-Type"] = "application/json"
          request["Authorization"] = bearer_token_with_api_key
        end
      end

      def http_client
        Net::HTTP.new(uri.host, @port).tap do |conn|
          conn.use_ssl = true if uri.instance_of?(URI::HTTPS)
        end
      end

      def uri
        URI.parse(@host)
      end

      def port
        return @port if !@port.nil? && @port.is_a?(Integer)
        uri.port
      end

      def bearer_token_with_api_key
        "Bearer " + Polynomal.config.api.key
      end
    end
  end
end
