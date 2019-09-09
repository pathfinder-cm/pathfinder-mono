require 'rails_helper'

RSpec.describe RemotesController, type: :controller do
  let(:valid_session) { {} }

  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
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
      before(:each) do
        @params = {
          remote: {
            name: 'barito-registry',
            server: 'https://cloud-images.ubuntu.com/releases',
            protocol: 'simplestreams',
            auth_type: 'none',
            certificate: ''
          }
        }
      end

      it "creates a new Remote" do
        expect {
          post :create, params: @params, session: valid_session
        }.to change(Remote, :count).by(1)
      end

      it "redirects to list of remotes" do
        post :create, params: @params, session: valid_session
        expect(response).to redirect_to(Remote.last)
      end
    end

    context "with invalid params" do
      before(:each) do
        remote = create(:remote)
        @params = {
          remote: {
            remote: remote.id
          }
        }
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: @params, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #show' do
    it 'fetches remote by id' do
      remote = create(:remote)
      get :show, params: { id: remote.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #update' do
    it 'edits remote by id' do
      remote = create(:remote)
      remote_params = {
        name: 'barito-registry',
        server: 'https://cloud-images.ubuntu.com/releases',
        protocol: 'simplestreams',
        auth_type: 'none',
        certificate: ''
      }
      post :update, params: { id: remote.id, remote: remote_params }
      expect(response).to have_http_status(302)
    end
  end
end
