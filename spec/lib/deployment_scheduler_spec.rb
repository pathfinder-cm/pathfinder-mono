require 'rails_helper'

RSpec.describe DeploymentScheduler do
  let(:deployment_scheduler) { DeploymentScheduler.new }

  describe "#schedule_single" do
    context "container doesn't exists" do
      it "create new container" do
        deployment = create(:deployment, name: 'hitsu-consul', count: rand(1..99))
        deployment_scheduler.schedule_single(deployment)

        expect(Container.pluck(:hostname)).to include(*deployment.container_names)
      end
    end
  end
end
