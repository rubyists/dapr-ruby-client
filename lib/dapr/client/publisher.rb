# frozen_string_literal: true

module Rubyists
  module Dapr
    module Client
      # Handles publishing messages to Dapr pub/sub topics
      class Publisher
        # Include the client module
        include Client

        # The name of the pubsub component, and the client
        attr_reader :pubsub_name, :client

        # The proto class for the publish event request
        Proto = Dapr::Proto::Runtime::V1::PublishEventRequest

        # Initialize the publisher
        # @param name [String] The name of the pubsub component in Dapr
        # @param serialization [Symbol] The serialization format to use. Defaults to :to_json
        #                               this can be :to_json, :to_dapr, or any object that responds to :wrap.
        #                               If it responds to :wrap, it will be called with the message to be sent.
        def initialize(name, serialization: :to_json)
          @serialization = serialization
          @pubsub_name = name
        end

        def publish(topic, message)
          singleton.publish_event(Proto.new(pubsub_name:, topic:, data: wrap(message)))
        end

        private

        def wrap(message)
          case serialization
          when :to_dapr, :to_json
            message.send(serialization)
          when ->(s) { s.respond_to?(:wrap) }
            serialization.wrap(message)
          else
            raise "Unknown serialization format: #{serialization}"
          end
        end
      end
    end
  end
end
