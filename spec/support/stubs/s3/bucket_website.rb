module Fake
  module S3
    class BucketWebsite
      attr_reader :bucket_name

      def initialize(bucket_name, options = {})
        @bucket_name = bucket_name
      end

      def put(configuration = {})
        
      end

    end
  end
end
