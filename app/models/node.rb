class Node < ApplicationRecord
  # Setup transient attributes for your model (attr_accessor)
  # e.g.
  # attr_accessor :temp
  attr_accessor :authentication_token

  # Setup validations for your model
  # e.g.
  # validates_presence_of :name
  # validates_uniqueness_of :name, case_sensitive: false
  validates :hostname,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: HOSTNAME_FORMAT },
    length: { minimum: 1, maximum: 255 }

  # Setup relations to other models
  # e.g.
  # has_one :user
  # has_many :users
  # has_and_belongs_to_many :users
  # has_many :employees, through: :users
  belongs_to :cluster
  has_many :containers

  #
  # Setup scopes
  #
  scope :schedulables, -> { where(schedulable: true) }

  #
  # Setup for additional gem-related configuration
  #

  #
  # Setup callbacks & state machines
  #
  before_save :hash_authentication_token

  #
  # Setup additional methods
  #
  def refresh_authentication_token
    authentication_token = SecureRandom.urlsafe_base64(48)
    self.authentication_token = authentication_token
    return authentication_token if save
    return nil
  end

  private
    def hash_authentication_token
      if self.authentication_token.present?
        self.hashed_authentication_token = Digest::SHA512.hexdigest self.authentication_token
        self.authentication_token_generated_at = DateTime.current
        self.authentication_token = nil
      end
    end
end
