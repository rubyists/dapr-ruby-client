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
        # The proto class for the Unlock request message
        UnlockRequest = ::Dapr::Proto::Runtime::V1::UnlockRequest
        DEFAULT_STORE_NAME = 'locker'

        # @param resource_id [String] The unique ID of the resource to lock
        # @param store_name [String]  The name of the Dapr lock store component to use
        # @param ttl [Integer] The time-to-live for the lock in seconds
        #
        # @return [Lock] The lock object
        def self.acquire(resource_id, store_name: DEFAULT_STORE_NAME, ttl: 10)
          lock = new(store_name, resource_id)
          lock.lock!(ttl:)
        end

        # Initialize the Lock
        #
        # @param store_name [String]  The name of the Dapr lock store component to use
        # @param resource_id [String] The unique ID of the resource to lock
        def initialize(store_name, resource_id)
          @store_name = store_name
          @resource_id = resource_id
        end

        # @param ttl [Integer] The time-to-live for the lock in seconds
        def lock!(ttl: 10)
          response = singleton.try_lock_alpha1 lock_request
          if response.success
            logger.info('Acquired lock', store_name:, resource_id:, ttl:, lock_owner:)
            return self
          end

          logger.warn "Failed to acquire lock for #{resource_id}"
          nil
        end

        def unlock!
          response = singleton.unlock_alpha1(UnlockRequest.new(store_name:, resource_id:, lock_owner:))
          status = response.status
          return true if status == :SUCCESS

          logger.warn('Unlock Failed!', status:, store_name:, resource_id:, lock_owner:)
          false
        end

        private

        # @return [String] The unique ID of the lock owner
        def lock_owner
          @lock_owner ||= SecureRandom.uuid
        end

        # @param ttl [Integer] The time-to-live for the lock in seconds
        #
        # @return [LockRequest] The lock request
        def lock_request(ttl: 10)
          @lock_request ||= LockRequest.new(store_name:, resource_id:, lock_owner:, expiry_in_seconds: ttl)
        end
      end
    end
  end
end
