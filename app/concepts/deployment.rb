module Concepts
  class Deployment
    attr_reader :from, :to

    DEFAULT_ACL = "public-read".freeze

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
      to_bucket
        .object(object.key)
        .copy_from(copy_source: "#{object.bucket_name}/#{object.key}", acl: DEFAULT_ACL)
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
