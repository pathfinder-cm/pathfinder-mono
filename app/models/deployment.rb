class Deployment < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: NAME_FORMAT },
    length: { minimum: 1, maximum: 255 }

  belongs_to :cluster

  def container_names
    (0..count-1).map{ |i| "#{name}-%02d" % (i+1) }
  end

  def managed_containers
    Container.exists.
      where("hostname ~* ?", managed_containers_hostname_regexp).
      where(cluster: cluster)
  end

  private
  def managed_containers_hostname_regexp
    "^#{Regexp.escape(name)}-[0-9]{2}$"
  end
end
