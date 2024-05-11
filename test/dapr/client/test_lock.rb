# frozen_string_literal: true

require_relative '../../test_helper'

# Tests for the Dapr Lock component
class TestDaprLock < Minitest::Test
  require Rubyists::Dapr::LIBROOT / :client / :lock
  DummyClient = Rubyists::Dapr::Client::DummyClient

  context 'Locking' do
    should 'Be able to acquire a lock' do
      DummyClient.define_method(:try_lock) do |*_args, &_block|
        Dapr::Proto::Runtime::V1::TryLockResponse.new(success: true)
      end
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
      DummyClient.define_method(:try_lock) do |*_args, &_block|
        Dapr::Proto::Runtime::V1::TryLockResponse.new(success: false)
      end
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
      DummyClient.define_method(:try_lock) do |*_args, &_block|
        Dapr::Proto::Runtime::V1::TryLockResponse.new(success: true)
      end
      DummyClient.define_method(:unlock) do |*_args, &_block|
        Dapr::Proto::Runtime::V1::UnlockResponse.new(status: 0)
      end
      messages = semantic_logger_events(Rubyists::Dapr::Client::Lock) do
        lock = Rubyists::Dapr::Client::Lock.acquire('test-lock')

        assert lock.unlock!
      end

      assert_equal 1, messages.size
      assert_semantic_logger_event messages.last, level: :info, message: 'Acquired lock'
    end

    should 'Fail to unlock a lock' do
      DummyClient.define_method(:try_lock) do |*_args, &_block|
        Dapr::Proto::Runtime::V1::TryLockResponse.new(success: true)
      end
      DummyClient.define_method(:unlock) do |*_args, &_block|
        Dapr::Proto::Runtime::V1::UnlockResponse.new(status: 1)
      end
      lock = Rubyists::Dapr::Client::Lock.acquire('test-lock')

      refute lock.unlock!
    end
  end
end
