require 'rails_helper'

RSpec.describe Api::V2::ExtApp::DeploymentsController, type: :controller do
  let(:cluster) { create(:cluster) }

  before(:each) do
    create(:ext_app, access_token: 'abc')
    request.headers['X-Auth-Token'] = 'abc'
  end

  describe "POST #bulk_apply" do
    context "new deployment" do
      it "creates new deployment" do
        params = {
          deployments: [
            {
              cluster_name: cluster.name,
              name: "hitsu-consul",
              count: 1,
              definition: {},
            },
            {
              cluster_name: cluster.name,
              name: "hitsu-elasticsearch",
              count: 5,
              definition: {},
            }
          ]
        }

        expect {
          post :bulk_apply, params: params, as: :json
        }.to change(Deployment, :count).by(2)
      end
    end

    context "deployment already exists" do
      before :each do
        @deployment_1 = create(
          :deployment, cluster: cluster, name: 'hitsu-consul', count: 1)
        @deployment_2 = create(
          :deployment, cluster: cluster, name: 'hitsu-elasticsearch', definition: {
            resource: {
              mem_limit: "256M",
            },
          })

        @params = {
          deployments: [
            {
              cluster_name: cluster.name,
              name: "hitsu-consul",
              count: 5,
            },
            {
              cluster_name: cluster.name,
              name: "hitsu-elasticsearch",
              definition: {
                resource: {
                  mem_limit: "512M"
                }
              },
            }
          ]
        }
        post :bulk_apply, params: @params, as: :json
        @deployment_1.reload
        @deployment_2.reload
      end

      it "updates the first deployment" do
        expect(@deployment_1.count).to eq(@params[:deployments][0][:count])
      end

      it "updates the second deployment" do
        expect(@deployment_2.definition).to eq(
          @params[:deployments][1][:definition].deep_stringify_keys
        )
      end
    end
  end

  describe "#GET containers" do
    it "returns an empty list if container doesn't exists" do
      deployment = create(:deployment, cluster: cluster, name: 'hitsu-redis', count: 0)
      params = {
        name: deployment.name
      }
      get :list_containers, params: params, as: :json
      response_hash = JSON.parse(response.body)
      resp = JSON.parse(::Api::V2::ExtApp::DeploymentSerializer.new(deployment).to_h.to_json)
      expect(response_hash).to eq resp
    end

    it "returns a list of containers created by the deployment" do

      deployment = create(:deployment, cluster: cluster, name: 'hitsu-consul', count: 1)
      container_1 = create(:container, hostname: "#{deployment.name}-01", cluster: cluster)
      container_2 = create(:container, hostname: "#{deployment.name}-02", cluster: cluster)
      params = {
        name: deployment.name
      }
      get :list_containers, params: params, as: :json
      response_hash = JSON.parse(response.body)
      resp = JSON.parse(::Api::V2::ExtApp::DeploymentSerializer.new(deployment).to_h.to_json)
      expect(response_hash).to eq resp
    end
  end
end
