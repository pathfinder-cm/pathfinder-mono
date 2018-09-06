class Container < ApplicationRecord
  before_create :set_default_values

  # Setup transient attributes for your model (attr_accessor)
  # e.g.
  # attr_accessor :temp
  enum statuses: {
    pending: 'PENDING',
    scheduled: 'SCHEDULED',
    provisioned: 'PROVISIONED',
    provision_error: 'PROVISION_ERROR',
    schedule_deletion: 'SCHEDULE_DELETION',
    deleted: 'DELETED',
  }

  # Setup validations for your model
  # e.g.
  # validates_presence_of :name
  # validates_uniqueness_of :name, case_sensitive: false
  validates :hostname,
    presence: true,
    format: { with: HOSTNAME_FORMAT },
    length: { minimum: 1, maximum: 255 }
  validate :unique_hostname_unless_deleted, if: :new_record?
  validates :image, presence: true

  # Setup relations to other models
  # e.g.
  # has_one :user
  # has_many :users
  # has_and_belongs_to_many :users
  # has_many :employees, through: :users
  belongs_to :cluster
  belongs_to :node, required: false

  #
  # Setup scopes
  #
  scope :pending, -> { 
    where(status: 'PENDING').order(last_status_update_at: :asc)
  }

  #
  # Setup for additional gem-related configuration
  #

  #
  # Setup callbacks & state machines
  #

  #
  # Setup additional methods
  #
  def update_status(status)
    status = status.downcase.to_sym
    if Container.statuses.key?(status)
      update_column(:status, Container.statuses[status])
      update_column(:last_status_update_at, DateTime.current)
    else
      false
    end
  end

  def allow_deletion?
    %w(PENDING SCHEDULED PROVISIONED PROVISION_ERROR).include? self.status
  end

  def allow_reschedule?
    %w(PROVISIONED PROVISION_ERROR).include? self.status
  end

  def unique_hostname_unless_deleted
    exists = Container.
      where('cluster_id = ?', self.cluster_id).
      where('hostname LIKE ?', self.hostname).
      where.not(status: ['DELETED', 'SCHEDULE_DELETION']).
      present?
    errors.add(:hostname, I18n.t('errors.messages.unique')) if exists
  end

  private
    def set_default_values
      self.status = Container.statuses[:pending]
      self.last_status_update_at = DateTime.current
    end
end
