# frozen_string_literal: true

require "spec_helper"

RSpec.describe Polynomal::Worker do
  let(:config) { Polynomal::Config.new }
  let(:transmitter) { Polynomal::Transmitter::Null.new }
  let!(:worker) { described_class.new(config: config, transmitter: transmitter) }

  after do
    Thread.list.each do |thread|
      next unless thread.is_a?(Polynomal::Worker::Thread)
      Thread.kill(thread)
    end
  end

  describe "#push" do
    it "should push a message into the queue" do
      expect(worker.send(:queue)).to receive(:push).with("bar")
      worker.push("bar")
    end

    context "when the queue is full" do
      before do
        allow(config).to receive(:max_queue_size).and_return(2)

        worker.push("foo")
        worker.push("bar")
      end

      it "logs a warning message" do
        expect(config.logger).to receive(:warn)
          .with("unable to report metric, max queue size reached. Dropping first item in queue")
        worker.push("baz")
      end

      it "does not push the item into the queue" do
        expect(worker.send(:queue)).not_to receive(:push)
        worker.push("baz")
      end
    end

    context "when the worker is shutdown" do
      before do
        allow(worker).to receive(:shutdown?).and_return(true)
      end

      it "returns false" do
        expect(worker.push("foo")).to be_falsey
      end
    end
  end

  describe "#start" do
    it "starts the thread" do
      expect { worker.start }.to change(worker, :thread).to(kind_of(Thread))
    end

    it "sets the new pid" do
      allow(Process).to receive(:pid).and_return(123)
      expect { worker.start }.to change(worker, :pid).to(123)
    end

    context "when the worker is shutdown" do
      before do
        worker.shutdown
      end

      it "does not start the thread" do
        expect { worker.start }.not_to change(worker, :thread)
      end
    end
  end

  describe "#shutdown" do
    before do
      worker.start
    end

    it "blocks until the queue is emptied" do
      expect(worker.send(:transmitter))
        .to receive(:transmit).with(kind_of(Symbol), anything)
        .and_call_original
      worker.push("foo")
      worker.shutdown
    end

    it "stops the thread" do
      worker.shutdown
      sleep(0.05)
      expect(worker.send(:thread)).not_to be_alive
    end

    it "sets the shutdown instance variable to be true" do
      worker.shutdown
      expect(worker.instance_variable_get(:@shutdown)).to be_truthy
    end

    it "clears the queue" do
      expect(worker.send(:queue)).to receive(:clear)
      worker.shutdown
    end

    context "when forced to shutdown" do
      it "does not block until the queue is emptied" do
        expect(worker.send(:transmitter)).not_to receive(:transmit)
        worker.push("foo")
        worker.shutdown(force: true)
      end
    end
  end
end
