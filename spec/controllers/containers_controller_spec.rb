require 'rails_helper'

RSpec.describe ContainersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Container. As you add validations to Container, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:container, cluster_id: @cluster.id)
  }

  let(:invalid_attributes) {
    { hostname: "" }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ContainersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user) { create(:user) }

  before(:each) do
    @cluster = create(:cluster)

    sign_in user
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {cluster_id: @cluster.id}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Container" do
        expect {
          post :create, params: {container: valid_attributes}, session: valid_session
        }.to change(Container, :count).by(1)
      end

      it "redirects to list of containers" do
        post :create, params: {container: valid_attributes}, session: valid_session
        expect(response).to redirect_to(@cluster)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {container: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "POST #schedule_deletion" do
    before(:each) do
      @container = create(:container, cluster: @cluster)
    end

    context "with valid params" do
      it "schedules container for deletion" do
        post :schedule_deletion, params: {id: @container.id}, session: valid_session
        @container.reload
        expect(@container.status).to eq "SCHEDULE_DELETION"
      end

      it "redirects to to list of containers" do
        post :schedule_deletion, params: {id: @container.id}, session: valid_session
        expect(response).to redirect_to(@cluster)
      end
    end
  end

  describe "POST #reschedule" do
    before(:each) do
      @container = create(:container, cluster: @cluster)
    end

    context "with valid params" do
      it "reschedules container" do
        post :reschedule, params: {id: @container.id}, session: valid_session
        @container.reload
        expect(@container.status).to eq "SCHEDULE_DELETION"
        expect(Container.last.status).to eq "PENDING"
      end

      it "redirects to to list of containers" do
        post :reschedule, params: {id: @container.id}, session: valid_session
        expect(response).to redirect_to(@cluster)
      end
    end
  end
end
