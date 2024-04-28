# frozen_string_literal: true

if ENV.fetch('COVERAGE', nil)
  require 'simplecov'
  require 'simplecov-json'
  formatters = [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::JSONFormatter]
  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new formatters
  SimpleCov.start do
    add_filter '/test/'
  end
end

require 'minitest/autorun'
require 'shoulda/context'
require_relative '../lib/dapr'
