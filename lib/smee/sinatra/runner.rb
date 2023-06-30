# frozen_string_literal: true

require "thread"
require "singleton"
require "smee"

module Smee::Sinatra
  class Runner

    class << self
      def start
        instance.start
      end

      def stop
        instance.stop
      end

      def running?
        instance.running?
      end

      def configured?
        instance.configured?
      end

      def should_run?
        !instance.production? && instance.configured?
      end
    end


    PROXY_URL_ENV_KEY = "WEBHOOK_PROXY_URL"

    TARGET_URL_PORT_ENV_KEY = "TARGET_PORT_KEY"
    TARGET_URL_PATH_ENV_KEY = "TARGET_PATH_KEY"
    TARGET_URL_HOST_ENV_KEY = "TARGET_HOST_KEY"
    TARGET_URL_SCHEME_ENV_KEY = "TARGET_SCHEME_KEY"

    include Singleton

    def initialize
      @thread = nil
      @client = nil
      @queue = Thread::Queue.new
    end

    def start
      return if running?
      @thread = Thread.new do
        run_smee_client
        wait_until_i_should_stop
        stop_smee_client
      end
    end

    def stop
      return unless running?
      @thread.kill
    end

    def running?
      @thread && @thread.alive?
    end

    def configured?
      ENV.key?("WEBHOOK_PROXY_URL") && !production?
    end

    def production?
      (
        ENV.key?("RAILS_ENV") && %w(prod production).include?(ENV["RAILS_ENV"]) ||
        ENV.key?("RACK_ENV") && %w(prod production).include?(ENV["RACK_ENV"])
      )
    end

    private

    def run_smee_client
      @client = SmeeClient.new(
        source: webhook_proxy_url,
        target: target_url
      )
      @client.start
    end

    def wait_until_i_should_stop
      while true
        begin
          @queue.pop(true)
          break :stop
        rescue ThreadError
          sleep 0.01
        end
      end
    end

    def stop_smee_client
      @client.stop
    end

    def webhook_proxy_url
      if ENV[PROXY_URL_ENV_KEY].start_with?("https://smee.io")
        ENV[PROXY_URL_ENV_KEY]
      else
        "https://smee.io/#{ENV[PROXY_URL_ENV_KEY]}"
      end
    end

    def target_url
      "#{target_scheme}://#{target_host}:#{target_port}#{target_path}"
    end

    def target_host
      ENV[TARGET_URL_HOST_ENV_KEY] || "localhost"
    end

    def target_port
      ENV[TARGET_URL_PORT_ENV_KEY] || "3000"
    end

    def target_scheme
      ENV[TARGET_URL_SCHEME_ENV_KEY] || "http"
    end

    def target_path
      if ENV.key?(TARGET_URL_PATH_ENV_KEY)
        value = ENV[TARGET_URL_PATH_ENV_KEY]
        value.start_with?("/") ? value : "/#{value}"
      else
        "/hook"
      end
    end

  end
end
