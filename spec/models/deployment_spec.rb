require 'rails_helper'

RSpec.describe Deployment, type: :model do
  let(:deployment) { build_stubbed(:deployment) }

  describe "validations" do
  end

  describe "relations" do
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
