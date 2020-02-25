class DeploymentScheduler
  def schedule_single(deployment)
    deployment.container_names.each do |container_name|
      Container.create(
          cluster_id: deployment.cluster_id,
          hostname: container_name,
          source: deployment.bootstrapper[:source],
          image_alias: deployment.bootstrapper[:image],
          bootstrappers: deployment.bootstrapper[:bootstrapper]
        )
    end
  end
end
