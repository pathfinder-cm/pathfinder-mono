require 'rails_helper'

RSpec.describe DeploymentsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Cluster. As you add validations to Cluster, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:deployment)
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DeploymentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user) { create(:user) }

  before(:each) do
    @cluster = create(:cluster)

    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "return a success response" do
      get :new, params: {cluster_id: @cluster.id}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      before(:each) do 
        deployment_params = attributes_for(:deployment, cluster: @cluster)
        @params = {
          deployments:
          {
            cluster_name: @cluster.name,
            name: deployment_params[:name],
            count: deployment_params[:count],
            definition: "#{deployment_params[:definition]}"
          }
        }
      end

      it "creates a new Deployment" do
        expect {
          post :create, params: @params, session: valid_session
        }.to change(Deployment, :count).by(1)
      end

      it "redirects to list of deployments" do
        post :create, params: @params, session: valid_session
        expect(response).to redirect_to(@cluster)
      end
    end
  end
end
