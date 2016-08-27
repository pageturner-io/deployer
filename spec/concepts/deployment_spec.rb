describe Concepts::Deployment do

  subject do
    described_class.new(source, target)
  end

  describe "#deploy!" do

    subject { super().deploy! }

    let(:source_name)          { "pageturner-builds" }
    let(:target_name)          { "pageturner-deployments-inf0rmer-inf0rmer.github.io" }
    let(:source_path)          { "inf0rmer/inf0rmer.github.io/1470750830/" }
    let(:source)               { Models::Source.new(source_name, source_path) }
    let(:target)               { Models::Source.new(target_name) }

    let(:source_bucket)        { Fake::S3::Bucket.new(source_name, objects: source_objects) }
    let(:target_bucket)        { Fake::S3::Bucket.new(target_name) }
    let(:bucket_website)       { Fake::S3::BucketWebsite.new(target_name) }
    let(:source_object_names) do
      [
        "assets/images/author.jpg",
        "assets/images/cover.jpg",
        "index.html"
      ]
    end
    let(:source_objects) do
      source_object_names.map do |name|
        [
          Fake::S3::Object.new(source_name, "inf0rmer/inf0rmer.github.io/1470750830/#{name}"),
          Fake::S3::Object.new(source_name, "inf0rmer/inf0rmer.github.io/123123213/#{name}")
        ]
      end.flatten
    end

    before :each do
      allow(Aws::S3::Bucket).to receive(:new).with(source_name) { source_bucket }
      allow(Aws::S3::Bucket).to receive(:new).with(target_name) { target_bucket }
      allow(target_bucket).to receive(:website) { bucket_website }
    end

    it "copies the contents of the given S3 object into the given bucket" do
      source_objects
        .select do |object|
          object.key.start_with?(source_path)
        end
        .each_with_index do |object, index|
          key = source_object_names[index]

          expect(object).to receive(:copy_to)
            .with(bucket: target_name, key: key, multipart_upload: true)
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
