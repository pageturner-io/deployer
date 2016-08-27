describe Consumers::BuildFinishes do

  subject { described_class.new }

  describe "#consume!" do

    subject do
      super().tap do |instance|
        instance.consume!
        exchange.publish(event[:message].to_json, event[:options])
      end
    end

    context "when a 'build:finished' event is triggered" do

      let(:deployment_double) { double(Concepts::Deployment) }
      let(:source_double)     { double(Models::Source) }
      let(:target_double)     { double(Models::Source) }
      let(:exchange)          { $rabbitmq_channel.topic("builds", durable: true) }
      let(:event) do
        {
          message: {
            name: "build:finished",
            id:   SecureRandom.hex,
            meta: {
              created_at: Time.now.iso8601(9),
              cid:        SecureRandom.hex,
              version:    1
            },
            payload: {
              repository: "inf0rmer/inf0rmer.github.io",
              location:   {
                host:   "s3",
                bucket: "pageturner-builds",
                object: "inf0rmer/inf0rmer.github.io/1470750830/"
              }
            }
          },
          options: {
            routing_key: "build:finished"
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
