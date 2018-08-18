class ExtApp < ApplicationRecord
  # Setup transient attributes for your model (attr_accessor)
  # e.g.
  # attr_accessor :temp
  attr_accessor :access_token

  # Setup validations for your model
  # e.g.
  # validates_presence_of :name
  # validates_uniqueness_of :name, case_sensitive: false
  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: NAME_FORMAT },
    length: { minimum: 4, maximum: 60 }
  validates :user_id, presence: true

  # Setup relations to other models
  # e.g.
  # has_one :user
  # has_many :users
  # has_and_belongs_to_many :users
  # has_many :employees, through: :users
  belongs_to :user

  #
  # Setup scopes
  #

  #
  # Setup for additional gem-related configuration
  #

  #
  # Setup callbacks & state machines
  #
  before_save :hash_access_token!

  #
  # Setup additional methods
  #
  def self.valid_access_token? challenge_token
    ExtApp.
      where(hashed_access_token: Digest::SHA512.hexdigest(challenge_token)).
      present?
  end

  private
    def hash_access_token!
      if self.access_token.present?
        self.hashed_access_token = Digest::SHA512.hexdigest self.access_token
        self.access_token_generated_at = DateTime.current
      end
    end
end
