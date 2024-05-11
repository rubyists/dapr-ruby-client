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
      lock = Rubyists::Dapr::Client::Lock.acquire('test-lock')

      assert lock
    end

    should 'Fail acquire a lock' do
      DummyClient.define_method(:try_lock) do |*_args, &_block|
        Dapr::Proto::Runtime::V1::TryLockResponse.new(success: false)
      end
      lock = Rubyists::Dapr::Client::Lock.acquire('test-lock')

      refute lock
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
      lock = Rubyists::Dapr::Client::Lock.acquire('test-lock')

      assert lock.unlock!
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
