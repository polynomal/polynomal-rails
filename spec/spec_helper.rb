# frozen_string_literal: true

require "pry"
require "logger"

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

ENV["RACK_ENV"] = nil
ENV["RAILS_ENV"] = nil

require "polynomal"
require "polynomal/transmitter/null"

NULL_LOGGER = Logger.new(IO::NULL)
NULL_LOGGER.level = Logger::Severity::DEBUG

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    Polynomal.configure do |c|
      c.api.host = "http://localhost:3000"
      c.api.key = "abc_123"
      c.logger = NULL_LOGGER
    end
  end

  config.after do
    Polynomal.stop(force: true)
  end
end
