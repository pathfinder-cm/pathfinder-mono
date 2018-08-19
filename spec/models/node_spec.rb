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
  end

  describe "gems" do
  end

  describe "callbacks" do
  end

  describe "methods" do
  end
end
