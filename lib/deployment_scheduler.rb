class DeploymentScheduler
  def schedule_single(deployment)
    deployment.container_names.each do |container_name|
      Container.create_with_source(deployment.cluster_id, {
        **deployment.definition.symbolize_keys,
        "hostname": container_name,
      })
    end
  end
end
