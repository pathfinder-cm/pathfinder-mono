require 'rails_helper'

RSpec.describe DeploymentScheduler do
  let(:deployment_scheduler) { DeploymentScheduler.new }
  let(:cluster) {create(:cluster)}

  describe "#schedule" do
    it "processes all deployments" do
      deployments = (1..3).map do
        create(:deployment, cluster: cluster, count: 3)
      end

      deployment_scheduler.schedule
      hostnames = Container.where(cluster: cluster).pluck(:hostname)
      expect(hostnames).to include(*deployments.flat_map {
        |deployment| deployment.container_names
      })
    end

    context "create operation" do
      context "no existing container" do
        before(:each) do
          @deployment = create(:deployment, name: 'hitsu-consul', count: 3)
          deployment_scheduler.schedule
        end

        it "creates containers" do
          hostnames = Container.where(cluster: @deployment.cluster).pluck(:hostname)
          expect(hostnames).to include(*@deployment.container_names)
        end

        it "creates containers with source" do
          container = Container.find_by(
            cluster: @deployment.cluster, hostname: @deployment.container_names.first)
          expect(container.source).not_to eq(nil)
        end
      end

      context "deleted container" do
        before(:each) do
          container = create(:container, cluster: cluster, hostname: 'hitsu-consul-01')
          container.status = Container.statuses[:deleted]
          container.save!

          create(:deployment, cluster: cluster, name: 'hitsu-consul', count: 2)
          deployment_scheduler.schedule
        end

        it "keeps creating containers" do
          containers = Container.where(cluster: cluster, hostname: 'hitsu-consul-01')
          expect(containers.count).to eq(2)
        end
      end
    end

    context "delete operation" do
      it "delete extra containers" do
        create(:container, cluster: cluster, hostname: 'hitsu-consul-01')
        create(:container, cluster: cluster, hostname: 'hitsu-consul-02')

        create(:deployment, cluster: cluster, name: 'hitsu-consul', count: 1)
        deployment_scheduler.schedule
        expect(Container.where(status: Container.statuses[:schedule_deletion]).pluck(:hostname)).to include("hitsu-consul-02")
      end

      it "doesn't delete deleted containers" do
        container = create(:container, cluster: cluster, hostname: 'hitsu-consul-01')
        container.status = Container.statuses[:deleted]
        container.save!

        create(:deployment, cluster: cluster, name: 'hitsu-consul', count: 0)
        deployment_scheduler.schedule
        container.reload
        expect(container.status).not_to eq(Container.statuses[:schedule_deletion])
      end
    end
  end
end
