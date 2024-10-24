# frozen_string_literal: true

require_relative '../../test_helper'

# Tests for the Dapr State Management component
class TestDaprState < Minitest::Test
  require Rubyists::Dapr::LIBROOT / :client / :state
  DummyClient = Rubyists::Dapr::Client::DummyClient
  Runtime = ::Dapr::Proto::Runtime::V1
  Common = ::Dapr::Proto::Common::V1
  Empty = Google::Protobuf::Empty

  def setup_dummy_client!
    DummyClient.define_method(:states) { @states ||= {} }
    define_get_bulk_state_method!
    define_set_bulk_state_method!
  end

  def define_get_bulk_state_method!
    DummyClient.define_method(:get_bulk_state) do |*args, &_block|
      items = args.shift.keys.map.with_index do |key, index|
        metadata = { key: "METAKEY-#{index}", value: "METAVALUE-#{index}" }
        data = "test-state-data-#{index}"
        Runtime::BulkStateItem.new(key:, data:, etag: '1', error: nil, metadata:)
      end
      Runtime::GetBulkStateResponse.new(items:)
    end
  end

  def define_set_bulk_state_method!
    DummyClient.define_method(:save_state) do |*args, &_block|
      args.shift.states.map { |s| states[s.key] = s.value }
      Empty
    end
  end

  def make_it_testy!
    return if testy?

    setup_dummy_client!
    @testy = true
  end

  def testy?
    @testy
  end

  context 'State' do
    should 'Read existing State item' do
      make_it_testy!
      messages = semantic_logger_events(Rubyists::Dapr::Client::State) do
        states = Rubyists::Dapr::Client::State.get('test_item1', 'test_item2')

        assert_equal 2, states.size
        assert_equal 'test-state-data-0', states['test_item1'].data
        assert_equal 'test-state-data-1', states['test_item2'].data
      end

      assert_equal 1, messages.size
      assert_semantic_logger_event messages.first, level: :debug, message: 'Getting state'
      refute_nil messages.first.payload[:keys]
    end

    should 'Set a State item' do
      make_it_testy!
      messages = semantic_logger_events(Rubyists::Dapr::Client::State) do
        items = { 'test_item1' => 'test-state-data-writes-0', 'test_item2' => 'test-state-data-writes-1' }
        response = Rubyists::Dapr::Client::State.set(items)

        assert_equal Empty, response
      end

      assert_equal 1, messages.size
      assert_semantic_logger_event messages.first, level: :debug, message: 'Setting state'
      assert_equal [{ key: 'test_item1', value: 'test-state-data-writes-0', metadata: {} },
                    { key: 'test_item2', value: 'test-state-data-writes-1', metadata: {} }],
                   messages.first.payload[:states]
    end
  end
end
