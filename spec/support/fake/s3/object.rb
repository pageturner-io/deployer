# frozen_string_literal: true
module Fake

  module S3

    class Object

      attr_reader :bucket, :key

      def initialize(bucket_name, key)
        @bucket = Bucket.new(bucket_name)
        @key    = key
      end

      def bucket_name
        bucket.name
      end

      def copy_from(copy_source:, acl:)
      end

      def copy_to(bucket:, key:, multipart_upload:)
      end

    end

  end

end
