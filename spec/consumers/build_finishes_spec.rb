# frozen_string_literal: true
require "app/consumers/build_finishes"

describe Consumers::BuildFinishes do

  subject { described_class.new }

  describe "#consume!" do

    subject do
      super().tap do |instance|
        instance.consume!
        Hivent::Signal.new("build:finished").emit(payload, version: 1)
      end
    end

    context "when a 'build:finished' event is triggered" do

      let(:deployment_double) { double(Concepts::Deployment) }
      let(:source_double)     { double(Models::Source) }
      let(:target_double)     { double(Models::Source) }
      let(:payload) do
        {
          repository: "inf0rmer/inf0rmer.github.io",
          location:   {
            host:   "s3",
            bucket: "pageturner-builds",
            object: "inf0rmer/inf0rmer.github.io/1470750830/"
          }
        }
      end

      before :each do
        allow(Models::Source).to receive(:new)
          .with("pageturner-builds", "inf0rmer/inf0rmer.github.io/1470750830/")
          .and_return(source_double)

        allow(Models::Source).to receive(:new)
          .with("pageturner-deployments-inf0rmer-inf0rmer.github.io")
          .and_return(target_double)

        allow(Concepts::Deployment).to receive(:new)
          .with(source_double, target_double)
          .and_return(deployment_double)

        allow(deployment_double).to receive(:deploy!)
      end

      it "deploys that build" do
        subject

        expect(deployment_double).to have_received(:deploy!)
      end

    end

  end

end
