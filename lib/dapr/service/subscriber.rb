# frozen_string_literal: true

require_relative '../service'

$stdout.sync = true

module Rubyists
  module Dapr
    module Service
      # The Subscriber class is a simple implementation of a Dapr subscriber service.
      class Subscriber
        include SemanticLogger::Loggable

        attr_reader(:service_proto, :runtime_proto, :pubsub_name, :topics, :event_handler)

        Port = ENV.fetch('DAPR_GRPC_APP_PORT', 50_051)

        def initialize(pubsub_name:,
                       topics:,
                       handler: nil,
                       service_proto: Dapr::Proto::Runtime::V1::AppCallback::Service,
                       runtime_proto: Dapr::Proto::Runtime::V1)
          @topics = Array(topics)
          @pubsub_name = pubsub_name
          @service_proto = service_proto
          @runtime_proto = runtime_proto
          @handler = handler
        end

        def handle_event!(topic_event, topic_call)
          return handler&.call(topic_event, topic_call) if handler.respond_to?(:call)

          logger.warn('Unhandled event: event handler does not respond to #call',
                      topic_event:,
                      topic_call:,
                      handler:)
        end

        def subscriptions
          @subscriptions ||= topics.map do |topic|
            runtime_proto::TopicSubscription.new(pubsub_name:, topic:)
          end
        end

        def service # rubocop:disable Metrics/MethodLength
          return @service if @service

          subscriber = self
          @service = Class.new(service_proto) do
            define_method(:on_topic_event) do |topic_event, topic_call|
              subscriber.handle_event!(topic_event, topic_call)
              Google::Protobuf::Empty.new
            end
            define_method(:list_topic_subscriptions) do |_empty, _call|
              subscriber.runtime_proto::ListTopicSubscriptionsResponse.new(subscriptions: subscriber.subscriptions)
            end
          end
        end

        def start!
          server = GRPC::RpcServer.new
          server.add_http2_port("0.0.0.0:#{Port}", :this_port_is_insecure)
          server.handle(service)
          log.warn('Starting Dapr Subscriber service', port: Port)
          server.run_till_terminated_or_interrupted([1, +'int', +'SIGQUIT'])
        end
      end
    end
  end
end
