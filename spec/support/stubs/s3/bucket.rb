module Fake
  module S3
    class Bucket
      attr_reader :name

      def initialize(name, objects: [])
        @name    = name
        @objects = objects
      end

      def objects(prefix: "")
        @objects.select do |object|
          object.key.start_with?(prefix)
        end
      end

    end
  end
end
