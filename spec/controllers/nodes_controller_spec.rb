require 'rails_helper'

RSpec.describe NodesController, type: :controller do

  let(:valid_attributes) {
    cluster = create(:cluster)
    attributes_for(:node, cluster_id: cluster.id)
  }
  let(:invalid_attributes) {
    { hostname: "" }
  }

  let(:valid_session) { {} }
  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe "GET #show" do
    it "returns a success response" do
      node = Node.create! valid_attributes
      get :show, params: {id: node.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #cordon" do
    it "cordons the node" do
      node = create(:node)
      post :cordon, params: { id: node.id }, session: valid_session

      expect(Node.schedulables).not_to include(node)
    end
  end
end
