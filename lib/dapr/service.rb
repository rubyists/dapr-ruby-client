# frozen_string_literal: true

require 'semantic_logger'
require 'dapr/proto/runtime/v1/appcallback_services_pb'
require_relative '../dapr'

module Rubyists
  module Dapr
    # Namespace for Dapr Service classes
    module Service
      include SemanticLogger::Loggable
    end
  end
end
