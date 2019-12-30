require 'rails_helper'

RSpec.describe ::Api::V2::Node::ContainersController do
  before(:each) do
    @cluster = create(:cluster)
    @node = create(:node, cluster: @cluster, authentication_token: 'abc')
    request.headers['X-Auth-Token'] = 'abc'
  end

  describe 'responds with scheduled' do
    before(:each) do
      c1 = create(:container, node: @node)
      c1.update_status(:scheduled)
      c2 = create(:container, node: @node)
      c2.update_status(:scheduled)
      c3 = create(:container, node: @node)
      c3.update_status(:schedule_deletion)
      @containers = [c3, c1, c2]
      create(:container, node: @node)
    end

    it "returns appropriate response" do
      get :scheduled, params: {cluster_name: @cluster.name, node_hostname: @node.hostname}, as: :json
      expect(response.body).to eq ::Api::V2::Node::ContainerSerializer.new(@containers).to_h.to_json
    end
  end

  describe 'responds with bootstrap_scheduled' do
    before(:each) do
      c1 = create(:container, node: @node)
      c1.update_status(:provisioned)
      c2 = create(:container, node: @node)
      c2.update_status(:provisioned)
      c3 = create(:container, node: @node)
      c3.update_status(:bootstrap_error)
      c4 = create(:container, node: @node)
      c4.update_status(:scheduled)
      @containers = [c1, c2]
      create(:container, node: @node)
    end

    it "returns appropriate response" do
      get :bootstrap_scheduled, params: {cluster_name: @cluster.name, node_hostname: @node.hostname}, as: :json
      expect(response.body).to eq ::Api::V2::Node::ContainerSerializer.new(@containers).to_h.to_json
    end
  end

  describe 'responds with mark_provisioned' do
    before(:each) do
      @container = create(:container, node: @node)
      @container.update_status('SCHEDULED')
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
      expect(response.body).to eq ::Api::V2::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end

  describe 'responds with mark_provision_error' do
    before(:each) do
      @container = create(:container, node: @node)
      @container.update_status('SCHEDULED')
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
      expect(response.body).to eq ::Api::V2::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end

  describe 'responds with mark_bootstrap_started' do
    before(:each) do
      @container = create(:container, node: @node)
      @container.update_status('PROVISIONED')
      @params = {
        cluster_name: @cluster.name,
        node_hostname: @container.node.hostname,
        hostname: @container.hostname
      }
    end

    it "mark object from provisioned to bootstrap_started in the database" do
      post :mark_bootstrap_started, params: @params, as: :json
      @container.reload
      expect(@container.status).to eq 'BOOTSTRAP_STARTED'
    end

    it "returns appropriate response" do
      post :mark_bootstrap_started, params: @params, as: :json
      @container.reload
      expect(response.body).to eq ::Api::V2::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end

  describe 'responds with mark_bootstrapped' do
    before(:each) do
      @container = create(:container, node: @node)
      @container.update_status('BOOTSTRAP_STARTED')
      @params = {
        cluster_name: @cluster.name,
        node_hostname: @container.node.hostname,
        hostname: @container.hostname
      }
    end

    it "mark object from bootstrap_started to bootstrapped in the database" do
      post :mark_bootstrapped, params: @params, as: :json
      @container.reload
      expect(@container.status).to eq 'BOOTSTRAPPED'
    end

    it "returns appropriate response" do
      post :mark_bootstrapped, params: @params, as: :json
      @container.reload
      expect(response.body).to eq ::Api::V2::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end

  describe 'responds with mark_bootstrap_error' do
    before(:each) do
      @container = create(:container, node: @node)
      @container.update_status('PROVISIONED')
      @params = {
        cluster_name: @cluster.name,
        node_hostname: @container.node.hostname,
        hostname: @container.hostname
      }
    end

    it "mark object from provisioned to bootstrap error in the database" do
      post :mark_bootstrap_error, params: @params, as: :json
      @container.reload
      expect(@container.status).to eq 'BOOTSTRAP_ERROR'
    end

    it "returns appropriate response" do
      post :mark_bootstrap_error, params: @params, as: :json
      @container.reload
      expect(response.body).to eq ::Api::V2::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end

  describe 'responds with mark_deleted' do
    before(:each) do
      @container = create(:container, node: @node)
      @container.update_status('SCHEDULE_DELETION')
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
      expect(response.body).to eq ::Api::V2::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end
end
