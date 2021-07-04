# frozen_string_literal: true

require "net/http"
require "uri"

module Polynomal
  module Transporter
    class HTTP
      def initialize(config: Polynomal.config)
        @host = config.host
        @port = config.port
      end

      def transport(payload)
        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = {
          application: {name: "Polynomal", environment: "production"},
          metric: payload
        }.to_json
        request["Content-Type"] = "application/json"
        http_connection.request(request)
      end

      private

      def http_connection
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
