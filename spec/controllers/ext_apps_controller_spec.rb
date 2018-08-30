require 'rails_helper'

RSpec.describe ExtAppsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # ExtApp. As you add validations to ExtApp, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:ext_app, user_id: user.id)
  }

  let(:invalid_attributes) {
    { name: "" }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ExtAppsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      ext_app = ExtApp.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      ext_app = ExtApp.create! valid_attributes
      get :show, params: {id: ext_app.to_param}, session: valid_session
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
      it "creates a new ExtApp" do
        expect {
          post :create, params: {ext_app: valid_attributes}, session: valid_session
        }.to change(ExtApp, :count).by(1)
      end

      it "redirects to the created ext_app" do
        post :create, params: {ext_app: valid_attributes}, session: valid_session
        expect(response).to redirect_to(ExtApp.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {ext_app: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      ext_app = ExtApp.create! valid_attributes
      get :edit, params: {id: ext_app.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:ext_app)
      }

      it "updates the requested ext_app" do
        ext_app = ExtApp.create! valid_attributes
        put :update, params: {id: ext_app.to_param, ext_app: new_attributes}, session: valid_session
        ext_app.reload
        expect(ext_app.name).to eq new_attributes[:name]
      end

      it "redirects to the ext_app" do
        ext_app = ExtApp.create! valid_attributes
        put :update, params: {id: ext_app.to_param, ext_app: valid_attributes}, session: valid_session
        expect(response).to redirect_to(ext_app)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        ext_app = ExtApp.create! valid_attributes
        put :update, params: {id: ext_app.to_param, ext_app: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end
end
