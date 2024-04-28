# frozen_string_literal: true

require_relative '../test_helper'

# Tests for the Dapr module
class TestDaprClient < Minitest::Test
  require Rubyists::Dapr::LIBROOT / :client
  context 'Dapr::Client' do
    should 'Provide a singleton instance' do
      c1 = Rubyists::Dapr::Client.singleton
      c2 = Rubyists::Dapr::Client.singleton

      assert_same c1, c2
    end

    should 'Provide a non-singleton instance' do
      c1 = Rubyists::Dapr::Client.client
      c2 = Rubyists::Dapr::Client.client

      refute_same c1, c2
    end
  end
end
