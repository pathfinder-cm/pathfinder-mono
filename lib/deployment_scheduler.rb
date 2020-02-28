class DeploymentScheduler
  def schedule
    Deployment.all.each do |deployment|
      process(deployment)
    end
  end

  private
  def process(deployment)
    wanted_hostnames = Set.new(deployment.container_names)

    process_existing_containers(deployment, wanted_hostnames) do |processed_container|
      wanted_hostnames.delete(processed_container.hostname)
    end
    process_new_containers(deployment, wanted_hostnames)
  end

  def process_existing_containers(deployment, wanted_hostnames)
    deployment.managed_containers.each do |container|
      hostname = container.hostname

      if wanted_hostnames.include?(hostname) then
        yield container
        update_container(deployment, container)
      else
        delete_container(container)
      end
    end
  end

  def process_new_containers(deployment, wanted_hostnames)
    wanted_hostnames.each do |hostname|
      create_container(deployment, hostname)
    end
  end

  def create_container(deployment, hostname)
    Container.create_with_source(deployment.cluster_id, {
      **container_param(deployment),
      "hostname": hostname,
    })
  end

  def update_container(deployment, container)
    container.apply_with_source(container_param(deployment))

    if container.changed?
      container.status = Container.statuses[:provisioned]
      container.save!
    end
  end

  def delete_container(container)
    container.update!(status: Container.statuses[:schedule_deletion])
  end

  def container_param(deployment)
    deployment.definition.deep_symbolize_keys
  end
end
