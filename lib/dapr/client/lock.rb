# frozen_string_literal: true

require 'securerandom'
require_relative '../client'

module Rubyists
  module Dapr
    module Client
      # Handles publishing messages to Dapr pub/sub topics
      class Lock
        # Include the client module
        include Client
        include SemanticLogger::Loggable

        # The name of the pubsub component, the client, and the serialization to use
        attr_reader :store_name, :resource_id, :lock

        # The proto class for the TryLock request message
        LockRequest = ::Dapr::Proto::Runtime::V1::TryLockRequest
        UnlockRequest = ::Dapr::Proto::Runtime::V1::UnlockRequest
        DEFAULT_STORE_NAME = 'locker'

        def self.acquire(resource_id, store_name: DEFAULT_STORE_NAME, ttl: 10)
          lock = new(store_name, resource_id)
          lock.lock!(ttl:)
        end

        # Initialize the publisher
        # @param name [String] The name of the pubsub component in Dapr
        # @param serialization [Symbol] The serialization format to use. Defaults to :to_json
        #                               this can be :to_json, :to_dapr, or any object that responds to :wrap.
        #                               If it responds to :wrap, it will be called with the message to be sent.
        def initialize(store_name, resource_id)
          @store_name = store_name
          @resource_id = resource_id
        end

        # @param ttl [Integer] The time-to-live for the lock in seconds
        def lock!(ttl: 10)
          response = singleton.try_lock(LockRequest.new(store_name:, resource_id:, lock_owner:, expiry_in_seconds: ttl))
          if response.success
            logger.info('Acquired lock', store_name:, resource_id:, ttl:, lock_owner:)
            return self
          end

          logger.warn "Failed to acquire lock for #{resource_id}"
          nil
        end

        def unlock!
          response = singleton.unlock(UnlockRequest.new(store_name:, resource_id:, lock_owner:))
          status = response.status
          return true if status == :SUCCESS

          logger.warn('Unlock Failed!', status:, store_name:, resource_id:, lock_owner:)
          false
        end

        private

        # @return [String] The unique ID of the lock owner
        def lock_owner
          return @lock_owner if defined?(@lock_owner)

          @lock_owner = SecureRandom.uuid
          @lock_owner
        end
      end
    end
  end
end
