require 'rails_helper'

RSpec.describe RemotesController, type: :controller do
  let(:valid_attributes) {
    attributes_for(:remote)
  }

  let(:invalid_attributes) {
    { name: '' }
  }

  let(:valid_session) { {} }

  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      remote = Remote.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      remote = Remote.create! valid_attributes
      get :show, params: {id: remote.to_param}, session: valid_session
      expect(response).to be_successful
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
      it "creates a new Remote" do
        expect {
          post :create, params: {remote: valid_attributes}, session: valid_session
        }.to change(Remote, :count).by(1)
      end

      it "redirects to the created remote" do
        post :create, params: {remote: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Remote.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {remote: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      remote = Remote.create! valid_attributes
      get :edit, params: {id: remote.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:remote)
      }

      it "updates the requested remote" do
        remote = Remote.create! valid_attributes
        put :update, params: {id: remote.to_param, remote: new_attributes}, session: valid_session
        remote.reload
        expect(remote.name).to eq new_attributes[:name]
      end

      it "redirects to the remote" do
        remote = Remote.create! valid_attributes
        put :update, params: {id: remote.to_param, remote: valid_attributes}, session: valid_session
        expect(response).to redirect_to(remote)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        remote = Remote.create! valid_attributes
        put :update, params: {id: remote.to_param, remote: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end
end