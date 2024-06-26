# frozen_string_literal: true

require_relative 'test_helper'

# Tests for the Dapr module
class TestDapr < Minitest::Test
  context 'Dapr' do
    should 'have a version number' do
      refute_nil ::Rubyists::Dapr::VERSION
    end
  end
end

# Load all the tests
Pathname(__dir__).join('dapr').glob('**/test_*.rb').each { |r| require_relative r }
