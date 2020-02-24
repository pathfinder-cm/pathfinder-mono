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
        deployment.count = 0
        expect(deployment.container_names).to eq []
      end

      it "returns list of container names" do
        deployment.count = 3
        expect(deployment.container_names).to match_array (1 .. 3).map{ |i| "#{deployment.name}-0#{i}" }
      end
    end
  end
end
