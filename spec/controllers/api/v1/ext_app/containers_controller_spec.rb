require 'rails_helper'

RSpec.describe ::Api::V1::ExtApp::ContainersController do
  let(:cluster) { create(:cluster) }
  let(:valid_attributes) {
    attributes_for(:container, cluster_id: cluster.id)
  }

  let(:invalid_attributes) {
    { hostname: "" }
  }

  before(:each) do
    create(:ext_app, access_token: 'abc')
    request.headers['X-Auth-Token'] = 'abc'
  end

  describe 'responds with show' do
    before(:each) do
      @container = create(:container, cluster: cluster)
      @params = {
        cluster_name: cluster.name,
        hostname: @container.hostname
      }
    end

    it "returns appropriate response" do
      get :show, params: @params, as: :json
      @container.reload
      expect(response.body).to eq ::Api::V1::ExtApp::ContainerSerializer.new(@container).to_h.to_json
    end
  end

  describe "POST #create" do
    context "with valid params" do
      before(:each) do
        @params = {
          cluster_name: cluster.name,
          container: valid_attributes
        }
      end

      it "creates a new Container" do
        expect {
          post :create, params: @params
        }.to change(Container, :count).by(1)
      end

      it "redirects to list of containers" do
        post :create, params: @params
        expect(response).to be_successful
      end
    end

    context "with invalid params" do
      it "returns a failed response" do
        @params = {
          cluster_name: cluster.name,
          container: invalid_attributes
        }
        post :create, params: @params
        expect(response.status).to eq 406
      end
    end
  end

  describe 'responds with schedule_deletion' do
    before(:each) do
      @container = create(:container, cluster: cluster)
      @params = {
        cluster_name: cluster.name,
        hostname: @container.hostname
      }
    end

    it "mark object as schedule_deletion in the database" do
      post :schedule_deletion, params: @params, as: :json
      @container.reload
      expect(@container.status).to eq 'SCHEDULE_DELETION'
    end

    it "returns appropriate response" do
      post :schedule_deletion, params: @params, as: :json
      @container.reload
      expect(response.body).to eq ::Api::V1::ExtApp::ContainerSerializer.new(@container).to_h.to_json
    end
  end
end
