# frozen_string_literal: true

require "spec_helper"
require "active_record"

RSpec.describe Polynomal::Instrumentation::ActiveRecord do
  before do
    @pool = if active_record_version >= Gem::Version.create("6.1.0.rc1")
      active_record_6_1_pool
    elsif active_record_version >= Gem::Version.create("6.0.0")
      active_record_6_0_pool
    elsif active_record_version >= Gem::Version.create("5.2.0")
      active_record_5_2_pool
    else
      raise "Unsupported active_record version"
    end
  end

  let(:collector) do
    Polynomal::Instrumentation::ActiveRecord.new
  end

  describe "test" do
    it "should do something?" do
      expect(collector.collect).to_not be(nil)
    end
  end

  def active_record_version
    Gem.loaded_specs["activerecord"].version
  end

  def active_record_5_2_pool
    ::ActiveRecord::ConnectionAdapters::ConnectionPool.new(
      OpenStruct.new(config: {})
    )
  end

  def active_record_6_0_pool
    ::ActiveRecord::ConnectionAdapters::ConnectionPool.new(
      OpenStruct.new(config: {})
    )
  end

  def active_record_6_1_pool
    ::ActiveRecord::ConnectionAdapters::ConnectionPool.new(
      OpenStruct.new(
        db_config: OpenStruct.new(
          checkout_timeout: 0,
          idle_timeout: 0,
          pool: 5
        )
      )
    )
  end
end
