# frozen_string_literal: true

require_relative '../client'

module Rubyists
  module Dapr
    module Client
      # The State class is a client for the Dapr State Management Building block
      # Info here: https://docs.dapr.io/developing-applications/building-blocks/state-management/
      class State
        # Include the client module
        include Client
        include SemanticLogger::Loggable

        attr_reader :store_name, :keys, :metadata

        Runtime            = Client::Runtime
        GetStateRequest    = Runtime::GetStateRequest
        GetStateResponse   = Runtime::GetStateResponse
        SetStateRequest    = Runtime::SetStateRequest
        SetStateResponse   = Runtime::SetStateResponse
        DEFAULT_STORE_NAME = 'dapr-statestore'

        # @param keys       [Array<String>] keys to retrieve from the state store
        # @param store_name [String]        name of the State Management component, defaults to 'dapr-statestore'
        # @param metadata   [Hash]          metadata to include
        #
        # @return [GetStateResponse] The response from the Dapr State Management component
        def self.get(keys, store_name: DEFAULT_STORE_NAME, metadata: {})
          new(store_name, metadata:).get(keys)
        end

        # Initialize the State Management client
        #
        # @param store_name [String]        name of the Dapr Configuration component to use
        # @param keys       [Array<String>] keys to retrieve from the state store
        # @param metadata   [Hash]          metadata to include
        def initialize(store_name, keys: [], metadata: {})
          @store_name = store_name
          @keys = Array(keys)
          @metadata = metadata
        end

        def get
          logger.debug('Getting state', keys:, store_name:)
          singleton.get_state GetStateRequest.new(store_name:, keys:, metadata:)
        end
      end
    end
  end
end
