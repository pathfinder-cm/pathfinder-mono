require 'rails_helper'

RSpec.describe DeploymentsController, type: :controller do
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DeploymentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user) { create(:user) }

  before(:each) do
    @cluster = create(:cluster)

    sign_in user
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
            desired_num_replicas: deployment_params[:desired_num_replicas],
            min_available_replicas: 1,
            definition: "#{deployment_params[:definition].to_json}"
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

    context "with invalid params" do
      before(:each) do
        @params = {
          deployments:
          {
            cluster_name: @cluster.name,
            name: "",
            definition: "{}"
          }
        }
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: @params, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      deployment = create(:deployment, cluster: @cluster)
      get :edit, params: {id: deployment.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      before(:each) do
        deployment_params = attributes_for(:deployment, cluster: @cluster)
        @params = {
          deployments:
          {
            cluster_name: @cluster.name,
            name: deployment_params[:name],
            desired_num_replicas: deployment_params[:desired_num_replicas],
            min_available_replicas: 2,
            definition: "#{deployment_params[:definition].to_json}"
          }
        }
      end

      it "update Deployment" do
        deployment = create(:deployment, cluster: @cluster)
        put :update, params: {id: deployment.to_param, deployments: @params[:deployments]}, session: valid_session
        deployment.reload
        expect(deployment.name).to eq @params[:deployments][:name]
      end

      it "redirects to list of deployments" do
        deployment = create(:deployment, cluster: @cluster)
        put :update, params: {id: deployment.to_param, deployments: @params[:deployments]}, session: valid_session

        expect(response).to redirect_to(@cluster)
      end
    end

    context "with invalid params" do
      before(:each) do
        deployment_params = attributes_for(:deployment, cluster: @cluster)
        @params = {
          deployments:
          {
            cluster_name: @cluster.name,
            name: "",
            definition: "{}"
          }
        }
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        deployment = create(:deployment, cluster: @cluster)
        put :update, params: {id: deployment.to_param, deployments: @params[:deployments]}, session: valid_session
        deployment.reload
        expect(response).to be_successful
      end
    end
  end
end
