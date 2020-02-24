class Deployment < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: NAME_FORMAT },
    length: { minimum: 1, maximum: 255 }

  belongs_to :cluster

  def container_names
    return (1..count).map{|i| "#{name}-0#{i}"} if count > 0
    []
  end
end
