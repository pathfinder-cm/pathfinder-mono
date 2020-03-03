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
    describe '#create_with_source!' do
      before(:each) do
        @cluster = create(:cluster)
        @remote = create(:remote)
      end

      it 'should automatically create source if source isn\'t exist yet' do
        source_params = attributes_for(:source)
        container_params = attributes_for(:container)
        valid_params = {
          hostname: container_params[:hostname],
          source: source_params.merge({ remote: { name: @remote.name } })
        }
        container = Container.create_with_source!(@cluster.id, valid_params)
        source = Source.last
        expect(source.source_type).to eq source_params[:source_type]
        expect(source.mode).to eq source_params[:mode]
        expect(source.remote_id).to eq @remote.id
        expect(source.fingerprint).to eq source_params[:fingerprint]
        expect(source.alias).to eq source_params[:alias]
      end

      it 'should use existing source if source already exist' do
        source = create(:source, remote: @remote)
        container_params = attributes_for(:container)
        valid_params = {
          hostname: container_params[:hostname],
          source: {
            source_type: source.source_type,
            mode: source.mode,
            remote: { name: @remote.name },
            fingerprint: source.fingerprint,
            alias: source.alias
          }
        }
        container = Container.create_with_source!(@cluster.id, valid_params)
        expect(container.source_id).to eq source.id
      end

      it 'should ensure supplied parameters are used correctly' do
        source = create(:source, remote: @remote)
        container_params = attributes_for(:container)
        valid_params = {
          hostname: container_params[:hostname],
          source: {
            source_type: source.source_type,
            mode: source.mode,
            remote: { name: @remote.name },
            fingerprint: source.fingerprint,
            alias: source.alias
          },
          bootstrappers: container_params[:bootstrappers]
        }
        container = Container.create_with_source!(@cluster.id, valid_params)
        expect(container.hostname).to eq valid_params[:hostname]
        expect(container.bootstrappers).to eq valid_params[:bootstrappers]
      end
    end

    describe '#apply_with_source' do
      let(:container) { create(:container) }
      let(:remote) { create(:remote) }
      let(:source) { create(:source, remote: remote) }

      before(:each) do
        container_params = attributes_for(:container)
        @valid_params = {
          source: {
            source_type: source.source_type,
            mode: source.mode,
            remote: { name: remote.name },
            fingerprint: source.fingerprint,
            alias: source.alias
          },
          bootstrappers: container_params[:bootstrappers]
        }
      end

      it 'update container based on params' do
        container.apply_with_source(@valid_params)
        expect(container.bootstrappers).to eq @valid_params[:bootstrappers]
      end

      it "doesn't update hostname" do
        previous_hostname = container.hostname
        @valid_params[:hostname] = "#{previous_hostname}-update"

        expect(container.hostname).to eq(previous_hostname)
      end
    end

    describe '#duplicate!' do
      it 'should be able to duplicate a container with only duplicable attributes set' do
        container = create(:container)
        duplicate_container = container.duplicate
        expect(duplicate_container.cluster_id).to eq container.cluster_id
        expect(duplicate_container.hostname).to eq container.hostname
        expect(duplicate_container.source).to eq container.source
        expect(duplicate_container.image_alias).to eq container.image_alias
        expect(duplicate_container.bootstrappers).to eq container.bootstrappers
      end
    end

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

    describe '#update_bootstrappers' do
      let(:container) { create(:container) }

      it 'shouldn\'t update bootstrapper for nil value' do
        bootstrappers_update = container.update_bootstrappers(nil)
        expect(bootstrappers_update).to eq(false)
      end

      it 'shouldn\'t update bootstrapper for empty value' do
        bootstrappers_update = container.update_bootstrappers("")
        expect(bootstrappers_update).to eq(false)
      end

      it 'should update container bootstrapper' do
        bootstrappers_params = [{ 'bootstrap_type' => 'none', 'bootstrap_url' => 'https://github.com/BaritoLog/chef-repo/archive/master.tar.gz'}]
        bootstrappers_update = container.update_bootstrappers(bootstrappers_params)
        expect(bootstrappers_update).to eq(true)
        expect(container.bootstrappers).to eq(bootstrappers_params)
      end
    end

    describe '#ready?' do
      before(:each) do
        Container.statuses.each do |_, status|
          container = create(:container)
          container.update!(status: status)
        end
      end

      it "returns true only if container is in bootstrapped state" do
        containers = Container.all.select { |container| container.ready? }
        expect(containers.all? { |container|
          container.status == Container.statuses[:bootstrapped]
        }).to be true
      end
    end
  end
end
