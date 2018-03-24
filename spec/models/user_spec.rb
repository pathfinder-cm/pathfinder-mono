require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { ::FactoryBot.build_stubbed(:user) }

  describe "validations" do
    it { should validate_presence_of(:username) }
    it { ::FactoryBot.create(:user); is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { should validate_presence_of(:email) }
    it { should allow_value('username@example.com').for(:email) }
    it { should_not allow_value('username').for(:email) }
    it { should validate_presence_of(:password) }

    context 'if new_record?' do
      before(:each) do
       allow(subject).to receive(:new_record?).and_return(true)
      end

      it { should validate_length_of(:password).is_at_least(8) }
      it { should validate_length_of(:password).is_at_most(128) }
      it { should validate_presence_of(:password_confirmation) }
    end
  end

  describe "relations" do
  end

  describe "scopes" do
  end

  describe "gems" do
  end

  describe "callbacks" do
  end

  describe "methods" do
    describe "#self.find_first_by_auth_conditions" do
      before(:each) do
        @user = ::FactoryBot.create(:user, username: "test_user")
      end

      it "should return user given username as login" do
        expect(User.find_first_by_auth_conditions({login: "test_user"})).to eq @user
      end
    end
  end
end
