require 'rails_helper'

RSpec.describe Source, type: :model do
  let(:source) { build(:source) }

  describe "validations" do
    it { should validate_presence_of(:type) }
    it { should validate_inclusion_of(:type).in_array(Source.types.values) }
    it { should validate_presence_of(:mode) }
    it { should validate_inclusion_of(:mode).in_array(Source.modes.values) }
  end

  describe "relations" do
    it { should belong_to(:remote) }
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
