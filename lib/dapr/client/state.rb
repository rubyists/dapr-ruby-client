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

        attr_reader :store_name

        Item                 = Struct.new(:data, :etag, :metadata)
        Empty                = Google::Protobuf::Empty
        Runtime              = Client::Runtime
        GetBulkStateResponse = Runtime::GetBulkStateResponse
        GetStateRequest      = Runtime::GetBulkStateRequest
        SaveStateRequest     = Runtime::SaveStateRequest
        DEFAULT_STORE_NAME   = 'statestore'

        # @param keys       [Array<String>] keys to retrieve from the state store
        # @param store_name [String]        name of the State Management component, defaults to 'dapr-statestore'
        # @param metadata   [Hash]          metadata to include
        #
        # @return [GetBulkStateResponse] The response from the Dapr State Management component
        def self.get(*keys, store_name: DEFAULT_STORE_NAME, metadata: {})
          new(store_name).get(keys, metadata:)
        end

        # @param states     [Hash]   states to set in the state store, key/value pairs
        # @param store_name [String] name of the State Management component, defaults to 'dapr-statestore'
        # @param metadata   [Hash]   metadata to include
        #
        # @return [Empty] The response from the Dapr State Management component
        def self.set(states, store_name: DEFAULT_STORE_NAME, metadata: {})
          new(store_name).set(states, metadata:)
        end

        # Initialize the State Management client
        #
        # @param store_name [String]        name of the Dapr Configuration component to use
        def initialize(store_name)
          @store_name = store_name
        end

        # @param keys       [Array<String>] keys to retrieve from the state store
        # @param metadata   [Hash]          metadata to include
        #
        # @return [Array<BulkStateItem>] Array of items returned by the state store
        def get(keys, metadata: {})
          logger.debug('Getting state', keys:, store_name:, metadata:)
          response = singleton.get_bulk_state GetStateRequest.new(store_name:, keys:, metadata:)
          response.items.to_h { |i| [i.key, Item.new(data: i.data, etag: i.etag, metadata: i.metadata)] }
        end

        # @param states     [Hash] states to set (key/values in the state store)
        # @param metadata   [Hash] metadata to include
        def set(states, metadata: {})
          states  = states.map { |key, value| { key:, value:, metadata: } }
          request = SaveStateRequest.new(store_name:, states:)
          logger.debug('Setting state', states:, store_name:)
          singleton.save_state request
        end
      end
    end
  end
end
