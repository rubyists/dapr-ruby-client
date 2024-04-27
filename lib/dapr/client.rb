# frozen_string_literal: true

require_relative '../dapr'
require 'json'
require 'semantic_logger'
require 'dapr-client'
require 'dapr/proto/runtime/v1/dapr_services_pb'

module Rubyists
  module Dapr
    # The namespace for the Dapr client
    module Client
      include SemanticLogger::Loggable
      DAPR_PORT = ENV.fetch('DAPR_GRPC_PORT', nil)
      DAPR_URI = ENV.fetch('DAPR_GRPC_HOST', 'localhost')
      DAPR_STUB = ::Dapr::Proto::Runtime::V1::Dapr::Stub

      def self.client
        return DummyClient.new if DAPR_PORT.nil?

        logger.info "Creating Dapr client for #{DAPR_URI}:#{DAPR_PORT}"
        DAPR_STUB.new("#{DAPR_URI}:#{DAPR_PORT}", :this_channel_is_insecure)
      end

      def self.singleton
        @singleton ||= client
      end

      def client
        Rubyists::Dapr::Client.client
      end

      def singleton
        @singleton ||= Rubyists::Dapr::Client.singleton
      end

      # Make a dummy client that responds to every method with a warning and the called method signature
      class DummyClient
        include SemanticLogger::Loggable

        def initialize(*_)
          logger.warn 'Dapr is not available (no DAPR_GRPC_PORT), using dummy client'
        end

        def method_missing(method_name, *)
          define_method(method_name) do |*args, &block|
            logger.warn 'Dapr is not available (no DAPR_GRPC_PORT), using dummy client'
            { method_name:, args:, block: }
          end
          send(method_name, *args, &block)
        end

        def respond_to_missing?(_method_name, _include_private = false)
          true
        end
      end
    end
  end
end
