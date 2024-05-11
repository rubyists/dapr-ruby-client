# frozen_string_literal: true

require_relative '../test_helper'

# Tests for the Dapr module
class TestDaprClient < Minitest::Test
  require Rubyists::Dapr::LIBROOT / :client

  class TestingClient
    include Rubyists::Dapr::Client
  end

  context 'Dapr::Client' do
    should 'Provide a singleton instance' do
      client = TestingClient.new
      c1 = client.singleton
      c2 = Rubyists::Dapr::Client.singleton

      assert_same c1, c2
    end

    should 'Provide a non-singleton instance' do
      client = TestingClient.new
      c1 = client.client
      c2 = Rubyists::Dapr::Client.client

      refute_same c1, c2
    end

    should 'Log a new client instance' do
      messages = semantic_logger_events(Rubyists::Dapr::Client) do
        client = Rubyists::Dapr::Client.client(dapr_port: 55_555)

        assert client
      end

      assert_equal 1, messages.size
    end
  end

  context 'Dapr::Client::DummyClient' do
    should 'Respond to unknown method with called signature' do
      dummy = Rubyists::Dapr::Client::DummyClient.new
      response = dummy.how_do_you('do', 'that') { 'thing-you-do' }

      assert_equal(:how_do_you, response[:method_name])
      assert_equal(%w[do that], response[:args])
      assert_equal('thing-you-do', response[:block].call)
    end

    should 'Respond true to respond_to_missing?' do
      dummy = Rubyists::Dapr::Client::DummyClient.new

      assert_respond_to(dummy, :how_do_you)
    end
  end
end
