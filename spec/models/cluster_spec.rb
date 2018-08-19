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
  end
end
