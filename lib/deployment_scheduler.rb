class DeploymentScheduler
  def schedule_single(deployment)
    containers = Container.where("hostname ~* ?", "^#{Regexp.escape(deployment.name)}-[0-9]{2}$").where(cluster: deployment.cluster).pluck(:hostname)
    container_names = deployment.container_names
    to_be_deleted = containers - container_names
    to_be_deleted.each do |container_name|
      Container.find_by(hostname: container_name).update(status: Container.statuses[:schedule_deletion])
    end

    deployment.container_names.each do |container_name|
      Container.create_with_source(deployment.cluster_id, {
        **deployment.definition.deep_symbolize_keys,
        "hostname": container_name,
      })
    end
  end
end
