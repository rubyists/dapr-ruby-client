# frozen_string_literal: true

require 'pathname'
require_relative 'dapr/version'

# Add a method to Pathname to join paths on /
class Pathname
  def /(other)
    join(other.to_s)
  end
end

module Rubyists
  module Dapr
    class Error < StandardError; end
    ROOT    = Pathname.new(__dir__).join('..').expand_path
    LIBROOT = ROOT.join('lib/dapr')
  end
end
