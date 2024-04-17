# frozen_string_literal: true

require_relative '../service'

$stdout.sync = true

module Rubyists
  module Dapr
    module Service
      # The Subscriber class is a simple implementation of a Dapr subscriber service.
      class Subscriber
        include SemanticLogger::Loggable

        attr_reader(:service_proto, :runtime_proto, :pubsub_name, :topics, :handler)

        # Create a new Subscriber instance.
        #
        # @param [String]               pubsub_name   name of the pubsub component
        # @param [String|Array<String>] topics        topic (or topics) to subscribe to
        # @param [Proc|Object]          handler       handler to call when an event is received. Must respond to #call
        # @param [Class]                service_proto Dapr Runtime Service Class to use for the subscriber
        # @param [Module]               runtime_proto Dapr Runtime Proto Module to use for the subscriber
        #
        # @return [Subscriber] the subscriber instance
        def initialize(pubsub_name:,
                       topics:,
                       handler: nil,
                       service_proto: ::Dapr::Proto::Runtime::V1::AppCallback::Service,
                       runtime_proto: ::Dapr::Proto::Runtime::V1)
          @topics = Array(topics)
          @pubsub_name = pubsub_name
          @service_proto = service_proto
          @runtime_proto = runtime_proto
          @handler = handler
        end

        # Start the subscriber service. This method will block until the service is terminated.
        # The service will listen on the specified port and address.
        #
        # @note if grpc_port is not provided, the service will listen on the port returned by the #port method.
        # @note the service will listen on all interfaces by default.
        #
        # @param [Integer] grpc_port the port to listen on
        # @param [String] listen_address the address to listen on
        #
        # @return [Subscriber] the subscriber instance
        def start!(grpc_port: nil, listen_address: '0.0.0.0')
          server = GRPC::RpcServer.new
          grpc_port ||= port
          listener = "#{listen_address}:#{grpc_port}"
          server.add_http2_port(listener, :this_port_is_insecure)
          server.handle(service)
          logger.warn('Starting Dapr Subscriber service', listen_address:, grpc_port:)
          server.run_till_terminated_or_interrupted([1, +'int', +'SIGQUIT'])
          self
        end

        def handle_event!(topic_event, topic_call)
          return handler&.call(topic_event, topic_call) if handler.respond_to?(:call)

          logger.warn('Unhandled event: event handler does not respond to #call',
                      topic_event:,
                      topic_call:,
                      handler:)
        end

        # @return [Array] The list of subscriptions for the Subscriber
        def subscriptions
          @subscriptions ||= topics.map do |topic|
            runtime_proto::TopicSubscription.new(pubsub_name:, topic:)
          end
        end

        private

        def port
          @port ||= ENV.fetch('DAPR_GRPC_APP_PORT', 50_051)
        end

        # @return [Class] the service class to use for the Subscriber
        def service # rubocop:disable Metrics/MethodLength
          return @service if @service

          subscriber = self
          @service = Class.new(service_proto) do
            include SemanticLogger::Loggable

            define_method(:on_topic_event) do |topic_event, topic_call|
              logger.debug "Received on_topic_event: #{topic_event}"
              subscriber.handle_event!(topic_event, topic_call)
              Google::Protobuf::Empty.new
            end

            define_method(:list_topic_subscriptions) do |_empty, _call|
              logger.debug 'Received list_topic_subscriptions'
              subscriber.runtime_proto::ListTopicSubscriptionsResponse.new(subscriptions: subscriber.subscriptions)
            end
          end
        end
      end
    end
  end
end
