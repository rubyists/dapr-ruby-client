# frozen_string_literal: true

require 'test_helper'
require 'shoulda/context'

class TestDapr < Minitest::Test
  context 'Dapr' do
    should 'have a version number' do
      refute_nil ::Rubyists::Dapr::VERSION
    end

    should 'do something useful' do
      assert false
    end
  end
end
