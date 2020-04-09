require 'rails_helper'

RSpec.describe ContainerScheduler do
  let(:scheduler) { ContainerScheduler.new }

  context "validation" do
    let!(:node) { create(:node) }
    let!(:container_1) { create(:container, cluster: node.cluster) }
    let!(:container_2) { create(:container, cluster: node.cluster) }
    let!(:container_3) { create(:container) }

    before(:each) do
      container_2.update_status(Container.statuses[:bootstrapped])
      scheduler.schedule

      container_1.reload
      container_2.reload
      container_3.reload
    end

    describe "container_1 (pending)" do
      it "is allocated to node" do
        expect(container_1.node).to eq(node)
      end

      it "has SCHEDULED status" do
        expect(container_1.status).to eq(Container.statuses[:scheduled])
      end
    end

    describe "container_2 (bootstrapped)" do
      it "is still in BOOTSTRAPPED state" do
        expect(container_2.status).to eq(Container.statuses[:bootstrapped])
      end
    end
  end
end
