module Consumers
  class BuildFinishes
    EVENT_NAME    = "build:finished".freeze
    EXCHANGE_NAME = "builds".freeze
    QUEUE_NAME    = "deployer".freeze

    def initialize
      @signal = Hivent::Signal.new(EVENT_NAME)
    end

    def consume!
      @signal.receive(version: 1) do |event|
        Concepts::Deployment.new(
          source_from(event[:payload]),
          target_from(event[:payload])
        ).deploy!
      end
    end

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
  end
end
