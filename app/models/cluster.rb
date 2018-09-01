class Cluster < ApplicationRecord
  # Setup transient attributes for your model (attr_accessor)
  # e.g.
  # attr_accessor :temp
  attr_accessor :password, :password_confirmation

  # Setup validations for your model
  # e.g.
  # validates_presence_of :name
  # validates_uniqueness_of :name, case_sensitive: false
  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: NAME_FORMAT },
    length: { minimum: 1, maximum: 255 }

  # Setup relations to other models
  # e.g.
  # has_one :user
  # has_many :users
  # has_and_belongs_to_many :users
  # has_many :employees, through: :users
  has_many :nodes
  has_many :containers

  #
  # Setup scopes
  #

  #
  # Setup for additional gem-related configuration
  #

  #
  # Setup callbacks & state machines
  #
  before_save :hash_password

  #
  # Setup additional methods
  #
  def authenticate challenge_password
    return false unless challenge_password.present?
    BCrypt::Password.new(hashed_password) == challenge_password
  end

  def get_node_by_authentication_token challenge_token
    return nil unless challenge_token.present?
    hashed_challenge_token = Digest::SHA512.hexdigest(challenge_token)
    self.nodes.find_by(hashed_authentication_token: hashed_challenge_token)
  end

  private
    def hash_password
      return unless password.present? && password == password_confirmation
      self.hashed_password = BCrypt::Password.create(password).to_s
      self.password_updated_at = DateTime.current
    end
end
