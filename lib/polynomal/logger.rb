# frozen_string_literal: true

require "logger"

module Polynomal
  class Logger < ::Logger
    PREFIX = "Polynomal"

    module Formatter
      class Pretty
        FORMAT = "%s, [%s #%d] %5s -- %s: %s\n"
        DATE_TIME_FORMAT = "%Y-%m-%dT%H:%M:%S.%6N"

        attr_accessor :datetime_format

        def initialize
          @datetime_format = DATE_TIME_FORMAT
        end

        def call(severity, time, progname, msg)
          FORMAT % [
            PREFIX,
            format_datetime(time),
            Process.pid,
            severity,
            progname,
            msg2str(msg)
          ]
        end

        private

        def format_datetime(time)
          time.strftime(@datetime_format)
        end

        def msg2str(msg)
          case msg
          when ::String
            msg
          when ::Exception
            "#{msg.message} (#{msg.class})\n#{msg&.backtrace&.join("\n") if msg&.backtrace}"
          else
            msg.inspect
          end
        end
      end
    end
  end
end
