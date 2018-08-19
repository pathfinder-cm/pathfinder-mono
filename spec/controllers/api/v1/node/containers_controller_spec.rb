require 'rails_helper'

RSpec.describe ::Api::V1::Node::ContainersController do
  describe 'responds with scheduled' do
    before(:each) do
      @node = create(:node)
      c1 = create(:container, node: @node, status: 'SCHEDULED')
      c1.update_status(:scheduled)
      c2 = create(:container, node: @node, status: 'SCHEDULED')
      c2.update_status(:scheduled)
      @containers = [c1, c2]
      create(:container, node: @node)
    end

    it "returns appropriate response" do
      get :scheduled, params: {node_hostname: @node.hostname}, as: :json
      expect(response.body).to eq ::Api::V1::Node::ContainerSerializer.new(@containers).to_h.to_json
    end
  end

  describe 'responds with provision' do
    before(:each) do
      @container = create(:container)
      @params = {
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
