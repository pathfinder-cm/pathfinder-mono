require 'rails_helper'

RSpec.describe Source, type: :model do
  let(:source) { build(:source) }

  describe "validations" do
    it { should validate_presence_of(:source_type) }
    it { should validate_inclusion_of(:source_type).in_array(Source.source_types.values) }
    it { should validate_inclusion_of(:mode).in_array(Source.modes.values).allow_nil }
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
