# frozen_string_literal: true

require_relative '../../test_helper'

# Tests for the Dapr Lock component
class TestDaprLock < Minitest::Test
  require Rubyists::Dapr::LIBROOT / :client / :lock
  DummyClient = Rubyists::Dapr::Client::DummyClient

  # Helper for when we want a lock acquisition to succeed
  def dress_for_success!
    DummyClient.define_method(:try_lock_alpha1) do |*_args, &_block|
      Dapr::Proto::Runtime::V1::TryLockResponse.new(success: true)
    end
  end

  # Helper for when we want a lock acquisition to fail
  def dress_for_failure!
    DummyClient.define_method(:try_lock_alpha1) do |*_args, &_block|
      Dapr::Proto::Runtime::V1::TryLockResponse.new(success: false)
    end
  end

  # Helper for how to respond to an unlock request
  # 0 = success
  # 1 = lock does not exist
  # 2 = lock is not owned by the caller
  # 3 = internal/unknown error
  #
  # @param status [Integer] The status to return to the unlock request
  def undress!(status: 0)
    # First we'll need to set up the lock method to succeed, so we have a lock to unlock
    dress_for_success!
    DummyClient.define_method(:unlock_alpha1) do |*_args, &_block|
      Dapr::Proto::Runtime::V1::UnlockResponse.new(status:)
    end
  end

  context 'Locking' do
    should 'Be able to acquire a lock' do
      dress_for_success!
      messages = semantic_logger_events(Rubyists::Dapr::Client::Lock) do
        lock = Rubyists::Dapr::Client::Lock.acquire('test-lock')

        assert lock
        assert_equal 'test-lock', lock.resource_id
      end

      assert_equal 1, messages.size
      assert_semantic_logger_event messages.first, level: :info, message: 'Acquired lock'
      refute_nil messages.first.payload[:lock_owner]
    end

    should 'Fail acquire a lock' do
      dress_for_failure!
      messages = semantic_logger_events(Rubyists::Dapr::Client::Lock) do
        lock = Rubyists::Dapr::Client::Lock.acquire('test-lock')

        assert_nil lock
      end

      assert_equal 1, messages.size
      assert_semantic_logger_event messages.first, level: :warn, message: 'Failed to acquire lock for test-lock'
    end
  end

  context 'Unlocking' do
    should 'Be able to unlock a lock' do
      undress!
      messages = semantic_logger_events(Rubyists::Dapr::Client::Lock) do
        lock = Rubyists::Dapr::Client::Lock.acquire('test-lock')

        assert lock.unlock!
      end

      assert_equal 1, messages.size
      assert_semantic_logger_event messages.last, level: :info, message: 'Acquired lock'
    end

    should 'Fail to unlock a lock for _reasons_' do
      %i[LOCK_DOES_NOT_EXIST LOCK_BELONGS_TO_OTHERS INTERNAL_ERROR].each_with_index do |status, i|
        undress! status: i + 1
        messages = semantic_logger_events(Rubyists::Dapr::Client::Lock) do
          lock = Rubyists::Dapr::Client::Lock.acquire('test-lock')

          refute lock.unlock!
        end

        assert_equal 2, messages.size
        assert_semantic_logger_event messages.last, level: :warn, message: 'Unlock Failed!'
        assert_equal status, messages.last.payload[:status]
      end
    end
  end
end
