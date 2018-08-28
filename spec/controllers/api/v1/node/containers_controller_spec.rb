require 'rails_helper'

RSpec.describe ::Api::V1::Node::ContainersController do
  describe 'responds with scheduled' do
    before(:each) do
      @cluster = create(:cluster)
      @node = create(:node, cluster: @cluster)
      c1 = create(:container, node: @node)
      c1.update_status(:scheduled)
      c2 = create(:container, node: @node)
      c2.update_status(:scheduled)
      c3 = create(:container, node: @node)
      c3.update_status(:schedule_deletion)
      @containers = [c1, c2, c3]
      create(:container, node: @node)
    end

    it "returns appropriate response" do
      get :scheduled, params: {cluster_name: @cluster.name, node_hostname: @node.hostname}, as: :json
      expect(response.body).to eq ::Api::V1::Node::ContainerSerializer.new(@containers).to_h.to_json
    end
  end

  describe 'responds with mark_provisioned' do
    before(:each) do
      @cluster = create(:cluster)
      @node = create(:node, cluster: @cluster)
      @container = create(:container, node: @node)
      @params = {
        cluster_name: @cluster.name,
        node_hostname: @container.node.hostname, 
        hostname: @container.hostname
      }
    end

    it "mark object as provisioned in the database" do
      post :mark_provisioned, params: @params, as: :json
      @container.reload
      expect(@container.status).to eq 'PROVISIONED'
    end

    it "returns appropriate response" do
      post :mark_provisioned, params: @params, as: :json
      @container.reload
      expect(response.body).to eq ::Api::V1::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end

  describe 'responds with mark_provision_error' do
    before(:each) do
      @cluster = create(:cluster)
      @node = create(:node, cluster: @cluster)
      @container = create(:container, node: @node)
      @params = {
        cluster_name: @cluster.name,
        node_hostname: @container.node.hostname, 
        hostname: @container.hostname
      }
    end

    it "mark object as provision_error in the database" do
      post :mark_provision_error, params: @params, as: :json
      @container.reload
      expect(@container.status).to eq 'PROVISION_ERROR'
    end

    it "returns appropriate response" do
      post :mark_provision_error, params: @params, as: :json
      @container.reload
      expect(response.body).to eq ::Api::V1::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end

  describe 'responds with mark_deleted' do
    before(:each) do
      @cluster = create(:cluster)
      @node = create(:node, cluster: @cluster)
      @container = create(:container, node: @node)
      @params = {
        cluster_name: @cluster.name,
        node_hostname: @container.node.hostname, 
        hostname: @container.hostname
      }
    end

    it "mark object as mark_deleted in the database" do
      post :mark_deleted, params: @params, as: :json
      @container.reload
      expect(@container.status).to eq 'DELETED'
    end

    it "returns appropriate response" do
      post :mark_deleted, params: @params, as: :json
      @container.reload
      expect(response.body).to eq ::Api::V1::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end
end
