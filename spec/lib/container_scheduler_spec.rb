require 'rails_helper'

RSpec.describe ContainerScheduler do
  describe "#process_cluster" do
    before(:each) do
      @cluster = create(:cluster)
    end

    context "Scheduler based on Memory" do
      before(:each) do
        ENV['SCHEDULER_TYPE'] = 'MEMORY'
        @node_1 = create(:node, cluster: @cluster, mem_used_mb: 10, mem_total_mb: 100)
        @node_2 = create(:node, cluster: @cluster, mem_used_mb: 90, mem_total_mb: 100)
        @node_3 = create(:node, cluster: @cluster, mem_used_mb: 5, mem_total_mb: 100)
      end

      it "should properly schedule containers to correct node" do
        c1 = create(:container, cluster: @cluster)
        c2 = create(:container, cluster: @cluster)
        c3 = create(:container, cluster: @cluster)
        ContainerScheduler.new.process_cluster(@cluster)
        c1.reload
        c2.reload
        c3.reload
        expect(c1.node).to eq @node_3
        expect(c2.node).to eq @node_1
        expect(c3.node).to eq @node_3
      end
    end

    context "Scheduler based on Container Number" do
      before(:each) do
        ENV['SCHEDULER_TYPE'] = 'CONTAINER_NUM'
        @node_1 = create(:node, cluster: @cluster)
        @node_2 = create(:node, cluster: @cluster)
        container = create(:container, cluster: @cluster, node: @node_2)
        container.update_status("SCHEDULED")
        container = create(:container, cluster: @cluster, node: @node_2)
        container.update_status("SCHEDULED")
        @node_3 = create(:node, cluster: @cluster)
      end

      it "should properly schedule containers to correct node" do
        c1 = create(:container, cluster: @cluster)
        c2 = create(:container, cluster: @cluster)
        c3 = create(:container, cluster: @cluster)
        ContainerScheduler.new.process_cluster(@cluster)
        c1.reload
        c2.reload
        c3.reload
        expect(c1.node).to eq @node_1
        expect(c2.node).to eq @node_3
        expect(c3.node).to eq @node_1
      end
    end
  end
end
