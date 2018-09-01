require 'rails_helper'

RSpec.describe ::Api::V1::Node::RegistrationsController do
  describe 'responds with register' do
    before(:each) do
      @cluster = create(:cluster, 
        password: 'abc', 
        password_confirmation: 'abc'
      )
    end

    context 'node already exist' do
      before(:each) do
        @node = create(:node, cluster: @cluster)
        @params = {
          cluster_name: @cluster.name,
          password: 'abc',
          node_hostname: @node.hostname,
        }
      end

      it 'refresh the authentication token' do
        current_token = @node.hashed_authentication_token
        post :register, params: @params, as: :json
        @node.reload
        expect(current_token).not_to eq @node.hashed_authentication_token
      end

      it 'returns appropriate response' do
        post :register, params: @params, as: :json
        expect(response).to be_successful
      end
    end

    context 'node is not exist' do
      before(:each) do
        @params = {
          cluster_name: @cluster.name,
          password: 'abc',
          node_hostname: 'test-01',
        }
      end

      it 'will create a new node' do
        post :register, params: @params, as: :json
        expect(Node.last.hostname).to eq 'test-01'
      end
    end
  end
end
