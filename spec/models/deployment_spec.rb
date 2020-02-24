require 'rails_helper'

RSpec.describe Deployment, type: :model do
  let(:deployment) { build_stubbed(:deployment) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(1).is_at_most(255) }
    it { create(:deployment); is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { should allow_value('IDENT_NAME').for(:name) }
    it { should allow_value('ident-name').for(:name) }
    it { should_not allow_value(' ident name').for(:name) }
  end

  describe "methods" do
    describe "#container_names" do
      it "returns empty list if count is 0" do
        expect(deployment.container_names).to eq []
      end
    end
  end
end
