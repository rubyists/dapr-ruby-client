# frozen_string_literal: true

require_relative '../client'

module Rubyists
  module Dapr
    module Client
      # Handles publishing messages to Dapr pub/sub topics
      class Configuration
        # Include the client module
        include Client
        include SemanticLogger::Loggable

        # The name of the configuration component, the keys we care about, and the metadata
        attr_reader :store_name, :keys, :metadata

        # The proto class for the GetConfiguration request
        ConfigurationRequest = ::Dapr::Proto::Runtime::V1::GetConfigurationRequest
        # The proto class for the GetConfiguration response
        ConfigurationResponse = ::Dapr::Proto::Runtime::V1::GetConfigurationResponse
        DEFAULT_STORE_NAME = 'payments-config'

        def self.get(keys = [], store_name: DEFAULT_STORE_NAME, metadata: {})
          configuration = new(store_name, keys:, metadata:)
          configuration.get
        end

        # Initialize the Configuration object
        #
        # @param store_name [String]  The name of the Dapr Configuration component to use
        # @param keys [Array<String>] The keys to retrieve from the configuration store (empty means all)
        # @param metadata [Hash] Optional metadata to pass to the Dapr configuration store
        def initialize(store_name, keys: [], metadata: {})
          @store_name = store_name
          @keys = Array(keys)
          @metadata = metadata
        end

        def get
          logger.debug('Getting configuration', keys:)
          singleton.get_configuration(ConfigurationRequest.new(store_name:, keys:, metadata:))
        end
      end
    end
  end
end
