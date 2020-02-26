require 'rails_helper'

RSpec.describe DeploymentScheduler do
  let(:deployment_scheduler) { DeploymentScheduler.new }
  let(:cluster) {create(:cluster)}

  describe "#schedule" do
    it "iterates deployments and call schedule_single" do
      n_deployment = rand(1..10)
      deployments = (1..n_deployment).map do
        create(:deployment, cluster: cluster, count: rand(1..3))
      end

      deployment_scheduler.schedule
      hostnames = Container.where(cluster: cluster).pluck(:hostname)
      expect(hostnames).to include(*deployments.flat_map {
        |deployment| deployment.container_names }
      )
    end
  end

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

    context "deployment count decrease" do
      it "delete extra containers" do
        create(:container, cluster: cluster, hostname: 'hitsu-consul-01')
        create(:container, cluster: cluster, hostname: 'hitsu-consul-02')
        deployment = create(:deployment, cluster: cluster, name: 'hitsu-consul', count: 1)

        deployment_scheduler.schedule_single(deployment)

        expect(Container.where(status: Container.statuses[:schedule_deletion]).pluck(:hostname)).to include("hitsu-consul-02")
      end
    end
  end
end
