describe Concepts::Deployment do

  subject do
    described_class.new(source, target)
  end

  describe "#deploy!" do

    subject { super().deploy! }

    let(:source_name)          { "pageturner-builds" }
    let(:target_name)          { "pageturner-deployments-inf0rmer-inf0rmer.github.io" }
    let(:source_path)          { "inf0rmer/inf0rmer.github.io/1470750830" }
    let(:source)               { Models::Source.new(source_name, source_path) }
    let(:target)               { Models::Source.new(target_name) }

    let(:source_bucket)        { Fake::S3::Bucket.new(source_name, objects: source_objects) }
    let(:target_bucket)        { Fake::S3::Bucket.new(target_name) }
    let(:bucket_website)       { Fake::S3::BucketWebsite.new(target_name) }
    let(:source_objects) do
      [
        Fake::S3::Object.new(source_name, "inf0rmer/inf0rmer.github.io/1470750830/assets/images/author.jpg"),
        Fake::S3::Object.new(source_name, "inf0rmer/inf0rmer.github.io/1470750830/assets/images/cover.jpg"),
        Fake::S3::Object.new(source_name, "inf0rmer/inf0rmer.github.io/1470750830/index.html"),
        Fake::S3::Object.new(source_name, "inf0rmer/inf0rmer.github.io/8192379812/index.html")
      ]
    end

    before :each do
      allow(Aws::S3::Bucket).to receive(:new).with(source_name) { source_bucket }
      allow(Aws::S3::Bucket).to receive(:new).with(target_name) { target_bucket }
      allow(target_bucket).to receive(:website) { bucket_website }

      source_objects.each do |object|
        allow(target_bucket).to receive(:object)
          .with(object.key)
          .and_return(object)
      end
    end

    it "copies the contents of the given S3 object into the given bucket" do
      source_objects
        .select do |object|
          object.key.start_with?(source_path)
        end
        .each do |object|
          expect(object).to receive(:copy_from)
            .with(copy_source: "#{source_name}/#{object.key}", acl: described_class::DEFAULT_ACL)
        end

      subject
    end

    it "does not copy objects that belong to another deployment" do
      source_objects
        .reject do |object|
          object.key.start_with?(source_path)
        end
        .each do |object|
          expect(object).not_to receive(:copy_from)
        end

      subject
    end

    it "sets up the given bucket to serve a website" do
      expect(bucket_website).to receive(:put)
        .with(
          index_document: { suffix: "index.html" }
        )

      subject
    end

  end

end
