class Remote < ApplicationRecord
  # Setup transient attributes for your model (attr_accessor)
  # e.g.
  # attr_accessor :temp
  enum protocols: {
    lxd: 'lxd',
    simplestreams: 'simplestreams',
  }

  enum auth_types: {
    tls: 'tls',
    plain: 'none',
  }

  # Setup validations for your model
  # e.g.
  # validates_presence_of :name
  # validates_uniqueness_of :name, case_sensitive: false
  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: NAME_FORMAT },
    length: { minimum: 1, maximum: 255 }
  validates :protocol,
    presence: true,
    inclusion: { in: protocols.values }
  validates :auth_type,
    presence: true,
    inclusion: { in: auth_types.values }

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

  #
  # Setup callbacks & state machines
  #

  #
  # Setup additional methods
  #
end
