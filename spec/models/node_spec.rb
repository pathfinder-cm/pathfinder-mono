require 'rails_helper'

RSpec.describe Node, type: :model do
  let(:node) { build_stubbed(:node) }

  describe "validations" do
    it { should validate_presence_of(:hostname) }
    it { create(:node); is_expected.to validate_uniqueness_of(:hostname).case_insensitive }
    it { should allow_value('ident-name').for(:hostname) }
    it { should_not allow_value('IDENT_NAME').for(:hostname) }
    it { should_not allow_value(' ident name').for(:hostname) }
  end

  describe "relations" do
    it { should belong_to(:cluster) }
    it { should have_many(:containers) }
  end

  describe "scopes" do
    describe "schedulables" do
      it "returns schedulable nodes only" do
        node_1 = create(:node)
        node_2 = create(:node, schedulable: false)

        expect(Node.schedulables).to eq [node_1]
      end
    end
  end

  describe "gems" do
  end

  describe "callbacks" do
  end

  describe "methods" do
    describe "#refresh_authentication_token" do
      it "should change node authentication token and return it" do
        node = create(:node)
        current_token = node.hashed_authentication_token
        node.refresh_authentication_token
        expect(current_token).not_to eq node.hashed_authentication_token
      end
    end
  end
end
