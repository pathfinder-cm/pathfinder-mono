require 'rails_helper'

RSpec.describe ::Api::V1::Node::ContainersController do
  describe 'responds with provision' do
    before(:each) do
      @container = create(:container)
      @attributes = {
        node_id: @container.node_id, 
        hostname: @container.hostname
      }
    end

    it "mark object as provisioned in the database" do
      post :provision, params: {data: @attributes}, as: :json
      @container.reload
      expect(@container.status).to eq 'PROVISIONED'
    end

    it "returns appropriate response" do
      post :provision, params: {data: @attributes}, as: :json
      @container.reload
      expect(response.body).to eq ::Api::V1::Node::ContainerSerializer.new(@container).to_h.to_json
    end
  end
end
