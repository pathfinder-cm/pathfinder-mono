require 'rails_helper'

RSpec.describe ContainerScheduler do
  let(:scheduler) { ContainerScheduler.new }
  let(:cluster) { create(:cluster) }

  before(:each) do
    @container_1 = create(:container, cluster: cluster)
    @container_2 = create(:container, cluster: cluster)
  end

  context "validation" do
    before(:each) do
      @node = create(:node, cluster: cluster)
      @container_2.update_status(Container.statuses[:bootstrapped])
      @container_3 = create(:container)
      scheduler.schedule

      @container_1.reload
      @container_2.reload
      @container_3.reload
    end

    describe "container_1 (pending)" do
      it "is allocated to node" do
        expect(@container_1.node).to eq(@node)
      end

      it "has SCHEDULED status" do
        expect(@container_1.status).to eq(Container.statuses[:scheduled])
      end
    end

    describe "container_2 (bootstrapped)" do
      it "is still in BOOTSTRAPPED state" do
        expect(@container_2.status).to eq(Container.statuses[:bootstrapped])
      end
    end

    describe "container_3 (pending, another cluster with no node)" do
      it "isn't allocated" do
        expect(@container_3.node).to eq(nil)
      end

      it "is still in PENDING state" do
        expect(@container_3.status).to eq(Container.statuses[:pending])
      end
    end
  end

  context "limits" do
    let(:containers) { Container.where(id: [@container_1.id, @container_2.id]) }

    let(:node_1) { create(:node, cluster: cluster) }
    let(:node_2) { create(:node, cluster: cluster) }

    describe "count limit" do
      before(:each) do
        3.times { create(:container, cluster: cluster, node: node_1).update_status(Container.statuses[:scheduled]) }
        2.times { create(:container, cluster: cluster, node: node_2).update_status(Container.statuses[:scheduled]) }

        ContainerScheduler.new(limit_n_containers: 2).schedule
      end

      it "adheres limit" do
        expect(containers.pluck(:node_id).compact).to eq([node_2.id])
      end
    end

    describe "memory limit" do
      before(:each) do
        node_1.update!(mem_used_mb: 71, mem_total_mb: 100)
        node_2.update!(mem_used_mb: 70, mem_total_mb: 100)

        ContainerScheduler.new(limit_mem_threshold: 70).schedule
      end

      it "adheres limit" do
        expect(containers.pluck(:node_id).compact).to eq([node_2.id, node_2.id])
      end
    end
  end
end
