class Deployment < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: NAME_FORMAT },
    length: { minimum: 1, maximum: 255 }

  belongs_to :cluster

  def container_names
    []
  end
end
