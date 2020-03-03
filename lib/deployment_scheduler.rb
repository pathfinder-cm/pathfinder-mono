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
    disruption_quota = calculate_disruption_quota(deployment)

    deployment.managed_containers.each do |container|
      if container.ready?
        next unless disruption_quota > 0
        disruption_quota -= 1
      end

      if wanted_hostnames.include?(container.hostname) then
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
    return unless [
      Container.statuses[:bootstrapped],
      Container.statuses[:bootstrap_error],
    ].include?(container.status)

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

  def calculate_disruption_quota(deployment)
    available_count = deployment.managed_containers.count(&:ready?)
    available_count - deployment.min_available_count
  end
end
