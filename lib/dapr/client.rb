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
      Runtime = ::Dapr::Proto::Runtime::V1
      DAPR_PORT = ENV.fetch('DAPR_GRPC_PORT', nil)
      DAPR_URI = ENV.fetch('DAPR_GRPC_HOST', 'localhost')
      DAPR_STUB = Runtime::Dapr::Stub

      def self.client(dapr_port: DAPR_PORT, dapr_uri: DAPR_URI)
        return DummyClient.new if dapr_port.nil?

        logger.info "Creating Dapr client for #{dapr_uri}:#{dapr_port}"
        DAPR_STUB.new("#{dapr_uri}:#{dapr_port}", :this_channel_is_insecure)
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

        def method_missing(method_name, *, &)
          self.class.define_method(method_name) do |*args, &block|
            logger.warn 'Dapr is not available (no DAPR_GRPC_PORT), using dummy client'
            { method_name:, args:, block: }
          end
          send(method_name, *, &)
        end

        def respond_to_missing?(_method_name, _include_private = false)
          true
        end
      end
    end
  end
end
