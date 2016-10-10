require "app/models/source"

module Concepts
  class Deployment
    attr_reader :from, :to

    def initialize(from, to)
      @from = from
      @to   = to
    end

    def deploy!
      from_bucket.objects(prefix: from.path).each do |object|
        copy(object)
      end

      to_bucket.website.put(
        index_document: { suffix: "index.html" }
      )
    end

    private

    def copy(object)
      from_bucket
        .object(object.key)
        .copy_to(
          bucket:           to.name,
          key:              unprefixed_key(object.key),
          multipart_upload: true
        )
    end

    def unprefixed_key(key)
      key.remove(from.path)
    end

    def from_bucket
      @from_bucket ||= bucket_from_source(from)
    end

    def to_bucket
      @to_bucket ||= bucket_from_source(to)
    end

    def bucket_from_source(source)
      Aws::S3::Bucket.new(source.name)
    end

  end
end
