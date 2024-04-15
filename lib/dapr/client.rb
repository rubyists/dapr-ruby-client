# frozen_string_literal: true

require_relative '../dapr'
require 'semantic_logger'
require 'dapr-client'
require 'dapr/proto/runtime/v1/dapr_services_pb'

module Rubyists
  module Dapr
    # The namespace for the Dapr client
    module Client
      include SemanticLogger::Loggable
      DAPR_PORT = ENV.fetch('DAPR_GRPC_PORT', '5001')
      DAPR_URI = ENV.fetch('DAPR_GRPC_HOST', 'localhost')
      DAPR_STUB = ::Dapr::Proto::Runtime::V1::Dapr::Stub

      def self.client
        logger.info "Creating Dapr client for #{DAPR_URI}:#{DAPR_PORT}"
        DAPR_STUB.new("#{DAPR_URI}:#{DAPR_PORT}", :this_channel_is_insecure)
      end

      def self.singleton
        @singleton ||= client
      end

      def client
        self.class.client
      end

      def singleton
        self.class.singleton
      end
    end
  end
end
