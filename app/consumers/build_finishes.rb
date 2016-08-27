module Consumers
  class BuildFinishes
    EVENT_NAME    = "build:finished".freeze
    EXCHANGE_NAME = "builds".freeze
    QUEUE_NAME    = "deployer".freeze

    def initialize
      queue.bind(exchange, routing_key: EVENT_NAME)
    end

    def consume!
      queue.subscribe(block: true) do |_delivery_info, _properties, message|
        payload = parse(message)[:payload]

        Concepts::Deployment.new(
          source_from(payload),
          target_from(payload)
        ).deploy!
      end
    end

    private

    def source_from(payload)
      bucket = payload[:location][:bucket]
      path   = payload[:location][:object]

      Models::Source.new(bucket, path)
    end

    def target_from(payload)
      repository = payload[:repository]
      bucket     = "#{ENV['S3_BUCKET_NAME']}-#{repository.gsub("/", "-")}"

      Models::Source.new(bucket)
    end

    def parse(message)
      @parsed_message ||= JSON.parse(message).with_indifferent_access
    end

    def queue
      @queue ||= $rabbitmq_channel.queue(QUEUE_NAME)
    end

    def exchange
      @exchange ||= $rabbitmq_channel.topic(EXCHANGE_NAME, durable: true)
    end
  end
end
