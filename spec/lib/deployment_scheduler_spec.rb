require 'rails_helper'

RSpec.describe DeploymentScheduler do
  let(:deployment_scheduler) { DeploymentScheduler.new }

  describe "#schedule_single" do
    context "container doesn't exists" do
      before(:each) do
        @deployment = create(:deployment, name: 'hitsu-consul', count: rand(1..99))
        deployment_scheduler.schedule_single(@deployment)
      end

      it "creates containers" do
        hostnames = Container.where(cluster: @deployment.cluster).pluck(:hostname)
        expect(hostnames).to include(*@deployment.container_names)
      end

      it "created containers have sources" do
        container = Container.find_by(
          cluster: @deployment.cluster, hostname: @deployment.container_names.first)
        expect(container.source).not_to eq(nil)
      end
    end
  end
end
