# frozen_string_literal: true

require 'test_helper'

# Tests for the Dapr module
class TestDapr < Minitest::Test
  context 'Dapr' do
    should 'have a version number' do
      refute_nil ::Rubyists::Dapr::VERSION
    end
  end
end
