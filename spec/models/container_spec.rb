require 'rails_helper'

RSpec.describe Container, type: :model do
  let(:container) { build(:container) }

  describe "validations" do
    it { should validate_presence_of(:hostname) }
    it { should allow_value('ident-name').for(:hostname) }
    it { should_not allow_value('IDENT_NAME').for(:hostname) }
    it { should_not allow_value(' ident name').for(:hostname) }

    describe "validate uniqueness of hostname" do
      before(:each) do
        @c1 = create(:container, 
          cluster_id: container.cluster_id, 
          hostname: container.hostname
        )
      end

      it "should reject if hostname is not unique across active containers" do
        container.save
        expect(container.errors.messages).to include(hostname: [I18n.t('errors.messages.unique')])
      end

      it "should accept if hostname is unique across active containers" do
        @c1.update_status("DELETED")
        expect(container.errors.messages).to be_empty
      end
    end
  end

  describe "relations" do
    it { should belong_to(:cluster) }
    it { should belong_to(:node) }
    it { should belong_to(:source) }
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



