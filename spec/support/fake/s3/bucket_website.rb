# frozen_string_literal: true
module Fake

  module S3

    class BucketWebsite

      attr_reader :bucket_name

      def initialize(bucket_name, _options = {})
        @bucket_name = bucket_name
      end

      def put(configuration = {})
      end

    end

  end

end
