require 'rails_helper'

RSpec.describe ::Api::V1::ExtApp::NodesController do
  let(:cluster) { create(:cluster) }

  before(:each) do
    create(:ext_app, access_token: 'abc')
    request.headers['X-Auth-Token'] = 'abc'
  end

  describe 'responds with index' do
    before(:each) do
      @node_1 = create(:node, cluster: cluster)
      @node_2 = create(:node, cluster: cluster)
      @node_3 = create(:node, cluster: cluster)
      @params = {
        cluster_name: cluster.name,
      }
    end

    it "returns appropriate response" do
      get :index, params: @params, as: :json
      expect(response.body).to eq ::Api::V1::ExtApp::NodeSerializer.new([@node_1, @node_2, @node_3]).to_h.to_json
    end
  end

  describe 'responds with show' do
    before(:each) do
      @node = create(:node, cluster: cluster)
      @params = {
        cluster_name: cluster.name,
        hostname: @node.hostname,
      }
    end

    it "returns appropriate response" do
      get :show, params: @params, as: :json
      expect(response.body).to eq ::Api::V1::ExtApp::NodeSerializer.new(@node).to_h.to_json
    end
  end
end
