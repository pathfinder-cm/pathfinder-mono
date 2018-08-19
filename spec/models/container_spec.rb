require 'rails_helper'

RSpec.describe Container, type: :model do
  let(:container) { build_stubbed(:container) }

  describe "validations" do
    it { should validate_presence_of(:hostname) }
    it { create(:container); is_expected.to validate_uniqueness_of(:hostname).case_insensitive }
    it { should allow_value('ident-name').for(:hostname) }
    it { should_not allow_value('IDENT_NAME').for(:hostname) }
    it { should_not allow_value(' ident name').for(:hostname) }
    it { should validate_presence_of(:image) }
  end

  describe "relations" do
    it { should belong_to(:cluster) }
    it { should belong_to(:node) }
  end

  describe "scopes" do
  end

  describe "gems" do
  end

  describe "callbacks" do
  end

  describe "methods" do
    describe '#update_status' do
      let(:container) { create(:container) }

      it 'shouldn\'t update status for invalid status type' do
        status_update = container.update_status('sample')
        expect(status_update).to eq(false)
      end

      it 'should update container status' do
        status = Container.statuses.keys.sample
        status_update = container.update_status(status)
        expect(status_update).to eq(true)
        expect(container.status.downcase).to eq(status)
      end
    end
  end
end



