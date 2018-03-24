class User < ApplicationRecord
  # Setup transient attributes for your model (attr_accessor)
  # e.g.
  # attr_accessor :temp
  attr_accessor :login

  # Setup validations for your model
  # e.g.
  # validates_presence_of :name
  # validates_uniqueness_of :name, case_sensitive: false
  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: USERNAME_FORMAT }
  validates :email,
    presence: true,
    format: { with: ::Devise.email_regexp }
  validates :password, presence: true, length: { in: 8..128 }, if: :new_record?
  validates :password_confirmation, presence: true, if: :new_record?

  # Setup relations to other models
  # e.g.
  # has_one :user
  # has_many :users
  # has_and_belongs_to_many :users
  # has_many :employees, through: :users

  #
  # Setup scopes
  #

  #
  # Setup for additional gem-related configuration
  #

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
    :registerable,
    :recoverable, 
    :rememberable, 
    :trackable
  validates_confirmation_of :password

  #
  # Setup callbacks & state machines
  #

  #
  # Setup additional methods
  #

  # Allow username to be used as authentication artifact
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value", { :value => login.downcase }]).first
    end
  end
end
