require 'rails_helper'

RSpec.describe ::Api::V1::Node::ContainersController do
  describe 'responds with scheduled' do
    before(:each) do
      @cluster = create(:cluster)
      @node = create(:node, cluster: @cluster)
      c1 = create(:container, node: @node, status: 'SCHEDULED')
      c1.update_status(:scheduled)
      c2 = create(:container, node: @node, status: 'SCHEDULED')
      c2.update_status(:scheduled)
      @containers = [c1, c2]
      create(:container, node: @node)
    end

    it "returns appropriate response" do
      get :scheduled, params: {cluster_name: @cluster.name, node_hostname: @node.hostname}, as: :json
      expect(response.body).to eq ::Api::V1::Node::ContainerSerializer.new(@containers).to_h.to_json
    end
  end

  describe 'responds with provision' do
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
      post :provision, params: @params, as: :json
      @container.reload
      expect(@container.status).to eq 'PROVISIONED'
    end

    it "returns appropriate response" do
      post :provision, params: @params, as: :json
      @container.reload
      expect(response.body).to eq ::Api::V1::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end
end
