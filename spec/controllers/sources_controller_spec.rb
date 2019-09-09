require 'rails_helper'

RSpec.describe SourcesController, type: :controller do
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
        remote = create(:remote)
        @params = {
          source: {
            source_type: "image",
            mode: "local",
            remote: remote.id,
            fingerprint: "",
            alias: "18.04"
          }
        }
      end

      it "creates a new Source" do
        expect {
          post :create, params: @params, session: valid_session
        }.to change(Source, :count).by(1)
      end

      it "redirects to list of sources" do
        post :create, params: @params, session: valid_session
        expect(response).to redirect_to(Source.last)
      end
    end

    context "with invalid params" do
      before(:each) do
        remote = create(:remote)
        @params = {
          source: {
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
    it 'fetches source by id' do
      source = create(:source)
      get :show, params: { id: source.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #update' do
    it 'edits source by id' do
      source = create(:source)
      remote = create(:remote)
      source_params = {
        source_type: "image",
        mode: "local",
        remote: remote.id,
        fingerprint: "",
        alias: "18.04"
      }
      post :update, params: { id: source.id, source: source_params }
      expect(response).to have_http_status(302)
    end
  end
end
