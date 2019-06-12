require 'rails_helper'

RSpec.describe Remote, type: :model do
  let(:remote) { build(:remote) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should allow_value('ident-name').for(:name) }
    it { should allow_value('IDENT_NAME').for(:name) }
    it { should_not allow_value(' ident name').for(:name) }
    it { should validate_presence_of(:protocol) }
    it { should validate_inclusion_of(:protocol).in_array(Remote.protocols.values) }
    it { should validate_presence_of(:auth_type) }
    it { should validate_inclusion_of(:auth_type).in_array(Remote.auth_types.values) }
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
  end
end
