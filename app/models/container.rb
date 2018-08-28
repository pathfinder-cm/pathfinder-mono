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
    uniqueness: { case_sensitive: false },
    format: { with: HOSTNAME_FORMAT },
    length: { minimum: 1, maximum: 255 }
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

  private
    def set_default_values
      self.status = Container.statuses[:pending]
      self.last_status_update_at = DateTime.current
    end
end
