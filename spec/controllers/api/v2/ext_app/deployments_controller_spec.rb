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
  end
end
