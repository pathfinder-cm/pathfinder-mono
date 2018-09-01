require 'rails_helper'

RSpec.describe Cluster, type: :model do
  let(:cluster) { build_stubbed(:cluster) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { create(:cluster); is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { should allow_value('IDENT_NAME').for(:name) }
    it { should allow_value('ident-name').for(:name) }
    it { should_not allow_value(' ident name').for(:name) }
  end

  describe "relations" do
    it { should have_many(:nodes) }
    it { should have_many(:containers) }
  end

  describe "scopes" do
  end

  describe "gems" do
  end

  describe "callbacks" do
  end

  describe "methods" do
    describe "#authenticate" do
      it "should return true if supplied password is valid" do
        cluster = create(:cluster, 
          password: 'abc', 
          password_confirmation: 'abc'
        )
        expect(cluster.authenticate('abc')).to eq true
      end

      it "should return false if supplied password is invalid" do
        cluster = create(:cluster, 
          password: 'abc', 
          password_confirmation: 'abc'
        )
        expect(cluster.authenticate('123')).to eq false
      end
    end

    describe "#get_node_by_authentication_token" do
      it "should return node based on supplied authentication_token" do
        node = create(:node, authentication_token: 'abc')
        expect(node.cluster.get_node_by_authentication_token('abc')).to eq node
      end
    end
  end
end
