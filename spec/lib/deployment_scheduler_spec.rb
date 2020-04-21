require 'rails_helper'

RSpec.describe DeploymentScheduler do
  let(:deployment_scheduler) { DeploymentScheduler.new }
  let(:cluster) { create(:cluster) }

  describe "#schedule" do
    it "processes all deployments" do
      deployments = (1..3).map do
        create(:deployment, cluster: cluster, desired_num_replicas: 3)
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
          @deployment = create(:deployment, name: 'hitsu-consul', desired_num_replicas: 3)
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

          create(:deployment, cluster: cluster, name: 'hitsu-consul', desired_num_replicas: 2)
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

        create(:deployment, cluster: cluster, name: 'hitsu-consul', desired_num_replicas: 1)
        deployment_scheduler.schedule
        expect(
          Container.where(status: Container.statuses[:schedule_deletion]).pluck(:hostname)
        ).to include("hitsu-consul-02")
      end

      it "doesn't delete deleted containers" do
        container = create(:container, cluster: cluster, hostname: 'hitsu-consul-01')
        container.status = Container.statuses[:deleted]
        container.save!

        create(:deployment, cluster: cluster, name: 'hitsu-consul', desired_num_replicas: 0,
                            min_available_replicas: 0)
        deployment_scheduler.schedule
        container.reload
        expect(container.status).not_to eq(Container.statuses[:schedule_deletion])
      end

      it "doesn't delete available container if container disruption quota is reached" do
        container = create(:container, cluster: cluster, hostname: 'hitsu-consul-01')
        container.update!(status: Container.statuses[:bootstrapped])

        create(:deployment, cluster: cluster, name: 'hitsu-consul', desired_num_replicas: 0,
                            min_available_replicas: 1)
        deployment_scheduler.schedule
        container.reload
        expect(container.status).not_to eq(Container.statuses[:schedule_deletion])
      end
    end

    context "update operation" do
      before(:each) do
        @deployment = create(:deployment, cluster: cluster, name: 'haja-consul', desired_num_replicas: 1,
                                          min_available_replicas: 0)
        deployment_scheduler.schedule

        @consul_box = Container.find_by(cluster: cluster, hostname: 'haja-consul-01')
      end

      context "bootstrapped containers" do
        before(:each) do
          @consul_box.update!(status: Container.statuses[:bootstrapped])
        end

        context "changed containers" do
          before(:each) do
            @consul_box.update!(bootstrappers: [{ 'bootstrap_type' => 'none' }])
          end

          context "apply_dirty = false" do
            before(:each) do
              deployment_scheduler.schedule
              @consul_box.reload
            end

            it "changes the attribute" do
              expect(@consul_box.bootstrappers).to eq(@deployment.definition['bootstrappers'])
            end

            it "changes container status" do
              expect(@consul_box.status).to eq(Container.statuses[:provisioned])
            end
          end

          context "apply_dirty = true" do
            before(:each) do
              @old_consul_box_status = @consul_box.status

              DeploymentScheduler.new(apply_dirty: true).schedule
              @consul_box.reload
            end

            it "doesn't changes container status" do
              expect(@consul_box.status).to eq(@old_consul_box_status)
            end
          end
        end

        context "changed containers with hit of container disruption quota" do
          before(:each) do
            @old_consul_box_status = @consul_box.status
            @old_consul_box_bootstrappers = @consul_box.bootstrappers

            @consul_box.update!(bootstrappers: [{ 'bootstrap_type' => 'none' }])
            @deployment.update!(min_available_replicas: 1)
          end

          it "doesn't change status of the container" do
            deployment_scheduler.schedule
            @consul_box.reload

            expect(@consul_box.status).to eq(@old_consul_box_status)
          end

          it "updates container without adhering disruption quota if apply_dirty = true" do
            DeploymentScheduler.new(apply_dirty: true).schedule
            @consul_box.reload

            expect(@consul_box.bootstrappers).to eq(@old_consul_box_bootstrappers)
          end
        end

        context "unchanged containers" do
          before(:each) do
            @old_consul_box_status = @consul_box.status

            deployment_scheduler.schedule
            @consul_box.reload
          end

          it "doesn't change status of the container" do
            expect(@consul_box.status).to eq(@old_consul_box_status)
          end
        end
      end

      context "containers which aren't bootstrapped" do
        context "changed containers" do
          before(:each) do
            @bootstrappers = [{ 'bootstrap_type' => 'none' }]
            @consul_box.update!(bootstrappers: @bootstrappers)

            deployment_scheduler.schedule
            @consul_box.reload
          end

          it "doesn't change attributes" do
            expect(@consul_box.bootstrappers).to eq(@bootstrappers)
          end
        end
      end
    end

    context "container disruption quota" do
      before(:each) do
        @deployment = create(:deployment, cluster: cluster, name: 'haja-consul', desired_num_replicas: 2,
                                          min_available_replicas: 1)
        deployment_scheduler.schedule

        @consul_1_box = Container.find_by(cluster: cluster, hostname: 'haja-consul-01')
        @consul_1_box.update!(status: Container.statuses[:bootstrapped])
        @consul_2_box = Container.find_by(cluster: cluster, hostname: 'haja-consul-02')
        @consul_2_box.update!(status: Container.statuses[:bootstrapped], bootstrappers: [{ 'bootstrap_type' => 'none' }])
        deployment_scheduler.schedule

        @consul_1_box.reload
        @consul_2_box.reload
      end

      it "still updates 2nd box" do
        expect(@consul_2_box.bootstrappers).to eq(@deployment.definition['bootstrappers'])
      end
    end

    context "$pf-meta script" do
      before(:each) do
        @deployment = create(:deployment, cluster: cluster, name: 'hasa-consul', desired_num_replicas: 1)
        @deployment.definition["bootstrappers"][0]["test"] = "$pf-meta:passthrough?value=text"
        @deployment.save!
        deployment_scheduler.schedule

        @consul_1_box = Container.find_by(cluster: cluster, hostname: 'hasa-consul-01')
      end

      it "is being parsed" do
        expect(@consul_1_box.bootstrappers[0]["test"]).to eq("text")
      end
    end

    context "$pf-meta script: function container_id" do
      before(:each) do
        @deployment = create(:deployment, cluster: cluster, name: 'hasa-consul', desired_num_replicas: 2)
        @deployment.definition["bootstrappers"][0]["result"] = "$pf-meta:container_id"
        @deployment.save!
        deployment_scheduler.schedule

        @consul_1_box = Container.find_by(cluster: cluster, hostname: 'hasa-consul-01')
        @consul_2_box = Container.find_by(cluster: cluster, hostname: 'hasa-consul-02')
      end

      it "assigns consul-1 as 1" do
        expect(@consul_1_box.bootstrappers[0]["result"]).to eq(1)
      end

      it "assigns consul-2 as 2" do
        expect(@consul_2_box.bootstrappers[0]["result"]).to eq(2)
      end
    end

    context "$pf-meta script: function deployment_host_sequences" do
      before(:each) do
        @deployment = create(:deployment, cluster: cluster, name: 'hasa-consul', desired_num_replicas: 2)
        @deployment.definition["bootstrappers"][0]["result"] =
          "$pf-meta:deployment_host_sequences?host=zookeeper.service.consul"
        @deployment.save!
        deployment_scheduler.schedule

        @consul_1_box = Container.find_by(cluster: cluster, hostname: 'hasa-consul-01')
        @consul_2_box = Container.find_by(cluster: cluster, hostname: 'hasa-consul-02')
      end

      it "assigns consul-1" do
        expect(@consul_1_box.bootstrappers[0]["result"]).to eq([
          "0.0.0.0", "2.zookeeper.service.consul"
        ])
      end

      it "assigns consul-2" do
        expect(@consul_2_box.bootstrappers[0]["result"]).to eq([
          "1.zookeeper.service.consul", "0.0.0.0"
        ])
      end
    end

    context "error" do
      before(:each) do
        @deployment = create(:deployment, cluster: cluster, name: 'hasa-consul', desired_num_replicas: 1)
        @deployment.definition["bootstrappers"][0]["result"] = "$pf-meta:unknown"
        @deployment.save!
        deployment_scheduler.schedule

        @deployment.reload
      end

      it "sets last_error_msg field" do
        expect(@deployment.last_error_msg.presence).not_to eq(nil)
      end

      it "sets last_error_at field" do
        expect(@deployment.last_error_at.presence).not_to eq(nil)
      end

      context "has been fixed" do
        before(:each) do
          @deployment.definition["bootstrappers"][0]["result"] = "text"
          @deployment.save!
          deployment_scheduler.schedule

          @deployment.reload
        end

        it "resets last_error_msg field" do
          expect(@deployment.last_error_msg.presence).to eq(nil)
        end

        it "resets last_error_at field" do
          expect(@deployment.last_error_at.presence).to eq(nil)
        end
      end
    end
  end
end
