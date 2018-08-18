require 'rails_helper'

RSpec.describe ExtApp, type: :model do
  let(:ext_app) { build_stubbed(:ext_app) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { create(:ext_app); is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { should allow_value('IDENT_NAME').for(:name) }
    it { should allow_value('ident-name').for(:name) }
    it { should_not allow_value(' ident name').for(:name) }
    it { should_not allow_value('a').for(:name) }
    it { should validate_presence_of(:user_id) }
  end

  describe "relations" do
    it { should belong_to(:user) }
  end

  describe "scopes" do
  end

  describe "gems" do
  end

  describe "callbacks" do
    describe "hash_access_token! before_save" do
      it "should hash access token and put it into hashed_access_token" do
        ext_app = create(:ext_app, access_token: "abc")
        expect(ext_app.hashed_access_token).to eq(
          Digest::SHA512.hexdigest("abc"))
      end
    end
  end

  describe "methods" do
    describe "self.valid_access_token?" do
      it "should return true if it finds matching access token" do
        ext_app = create(:ext_app, access_token: "abc")
        expect(ExtApp.valid_access_token?("abc")).to eq true
      end
    end
  end
end
