require 'rails_helper'

RSpec.describe ClustersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Cluster. As you add validations to Cluster, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:cluster)
  }

  let(:invalid_attributes) {
    { name: "" }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ClustersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      cluster = Cluster.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      cluster = Cluster.create! valid_attributes
      get :show, params: {id: cluster.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Cluster" do
        expect {
          post :create, params: {cluster: valid_attributes}, session: valid_session
        }.to change(Cluster, :count).by(1)
      end

      it "redirects to the created cluster" do
        post :create, params: {cluster: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Cluster)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {cluster: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      cluster = Cluster.create! valid_attributes
      get :edit, params: {id: cluster.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:cluster)
      }

      it "updates the requested cluster" do
        cluster = Cluster.create! valid_attributes
        put :update, params: {id: cluster.to_param, cluster: new_attributes}, session: valid_session
        cluster.reload
        expect(cluster.name).to eq new_attributes[:name]
      end

      it "redirects to the cluster" do
        cluster = Cluster.create! valid_attributes
        put :update, params: {id: cluster.to_param, cluster: valid_attributes}, session: valid_session
        expect(response).to redirect_to(cluster)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        cluster = Cluster.create! valid_attributes
        put :update, params: {id: cluster.to_param, cluster: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end
end
