# frozen_string_literal: true

require "net/http"
require "uri"

module Polynomal
  module Transporter
    class HTTP
      def initialize(config: Polynomal.config)
        @host = config.api.host
        @port = config.api.port
      end

      def transport(payload)
        request_body = {
          application: {name: "Polynomal", environment: "production"},
          metric: payload
        }

        http_client.request(post(request_body))
      end

      private

      def post(payload)
        Net::HTTP::Post.new(uri.request_uri).tap do |request|
          request.body = payload.to_json
          request["Content-Type"] = "application/json"
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
    end
  end
end
