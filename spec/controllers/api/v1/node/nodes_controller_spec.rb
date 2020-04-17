require 'rails_helper'

RSpec.describe ::Api::V1::Node::NodesController do
  before(:each) do
    @cluster = create(:cluster)
    @node = create(:node, cluster: @cluster, authentication_token: 'abc')
    request.headers['X-Auth-Token'] = 'abc'
  end

  describe 'store metrics from agent' do
    it 'return appropriate response' do
      params = {
        cluster_name: @cluster.name,
        memory: {
          used: 10,
          free: 20,
          total: 30
        },
        load: {
          capacity: 10,
          load_avg_1m: 1,
          load_avg_5m: 5,
          load_avg_15m: 15,
        },
        disk_root: {
          total: 10,
          used: 8,
        },
        disk_zfs: {
          total: 100,
          used: 5,
        },
      }
      post :store_metrics, params: params, as: :json
      expect(response.body).to eq ::Api::V1::Node::NodeSerializer.new(@node.reload).to_h.to_json
    end

    it 'still works even some metrics is missing' do
      params = {
        cluster_name: @cluster.name,
        memory: {
          used: 10,
          total: 30
        },
      }

      post :store_metrics, params: params, as: :json
      expect(response.body).to eq ::Api::V1::Node::NodeSerializer.new(@node.reload).to_h.to_json
    end
  end
end
