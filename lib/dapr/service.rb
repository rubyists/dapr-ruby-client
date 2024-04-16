# frozen_string_literal: true

require_relative '../dapr'
require 'dapr/proto/runtime/v1/appcallback_services_pb'

module Rubyists
  module Dapr
    # Namespace for Dapr Service classes
    module Service
      include SemanticLogger::Loggable
    end
  end
end
