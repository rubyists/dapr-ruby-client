# frozen_string_literal: true

require_relative '../../test_helper'

# Tests for the Dapr Configuration component
class TestDaprConfiguration < Minitest::Test
  require Rubyists::Dapr::LIBROOT / :client / :configuration
  DummyClient = Rubyists::Dapr::Client::DummyClient
  Runtime = ::Dapr::Proto::Runtime::V1
  Common = ::Dapr::Proto::Common::V1

  def make_it_testy!
    return if testy?

    DummyClient.define_method(:get_configuration) do |*_args, &_block|
      item = Common::ConfigurationItem.new(value: 'test-value', version: '1', metadata: { 'METAKEY' => 'METAVALUE' })
      Runtime::GetConfigurationResponse.new(items: { 'TEST_KEY' => item })
    end
    @testy = true
  end

  def testy?
    @testy
  end

  context 'Configuration' do
    should 'Read existing Configuration key' do
      make_it_testy!
      messages = semantic_logger_events(Rubyists::Dapr::Client::Configuration) do
        config = Rubyists::Dapr::Client::Configuration.get('TEST_KEY')
        item = config.items['TEST_KEY']

        assert_equal 'test-value', item.value
      end

      assert_equal 1, messages.size
      assert_semantic_logger_event messages.first, level: :debug, message: 'Getting configuration'
      refute_nil messages.first.payload[:keys]
    end
  end
end
