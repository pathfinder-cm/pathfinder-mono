class DeploymentScheduler
  def initialize(definition_parser = DeploymentDefinitionParser.new)
    @definition_parser = definition_parser
  end

  def schedule
    deployment_count = 0

    elapsed_time = Benchmark.realtime do
      Deployment.find_each do |deployment|
        begin
          process(deployment)
          if deployment.last_error_msg != nil or deployment.last_error_at != nil
            deployment.update!(last_error_msg: nil, last_error_at: nil)
          end
        rescue Exception => e
          deployment.update!(last_error_msg: "#{e.class.name}: #{e.message}", last_error_at: Time.now)
          p "#{deployment.name}: Error: #{e.class.name}: #{e.message}"
        end

        deployment_count += 1
      end
    end

    p "#{deployment_count} deployment(s) has been reconciled in #{'%.4f' % elapsed_time}s."
  end

  private
  def process(deployment)
    desired_replica_hostnames = Set.new(deployment.container_names)

    process_available_replicas(deployment, desired_replica_hostnames) do |processed_container|
      desired_replica_hostnames.delete(processed_container.hostname)
    end
    process_new_containers(deployment, desired_replica_hostnames)
  end

  def process_available_replicas(deployment, desired_replica_hostnames)
    disruption_quota = calculate_disruption_quota(deployment)

    deployment.managed_containers.each do |container|
      disruption_quota_in_effect = false
      if container.ready?
        unless disruption_quota > 0
          p "#{deployment.name}: Unable to update #{container.hostname}: No disruption quota left"
          next
        end
        disruption_quota_in_effect = true
      end

      result = process_container(deployment, desired_replica_hostnames, container) do
        yield container
      end
      if result and disruption_quota_in_effect
        disruption_quota -= 1
      end
    end
  end

  def process_new_containers(deployment, desired_replica_hostnames)
    desired_replica_hostnames.each do |hostname|
      create_container(deployment, hostname)
    end
  end

  def process_container(deployment, desired_replica_hostnames, container)
    if desired_replica_hostnames.include?(container.hostname) then
      yield container
      update_container(deployment, container)
    else
      delete_container(container)
    end
  end

  def create_container(deployment, hostname)
    Container.create_with_source(deployment.cluster_id, {
      **container_param(deployment, hostname),
      "hostname": hostname,
    })
  end

  def update_container(deployment, container)
    return unless [
      Container.statuses[:bootstrapped],
      Container.statuses[:bootstrap_error],
    ].include?(container.status)

    container.apply_params_with_source(container_param(deployment, container.hostname))
    return false unless container.changed?

    container.status = Container.statuses[:provisioned]
    container.save!
    true
  end

  def delete_container(container)
    container.update!(status: Container.statuses[:schedule_deletion])
    true
  end

  def container_param(deployment, container_hostname)
    context = DefinitionContext.new(deployment, container_hostname)
    @definition_parser.parse(context, deployment.definition.deep_symbolize_keys)
  end

  def calculate_disruption_quota(deployment)
    available_count = deployment.managed_containers.count(&:ready?)
    available_count - deployment.min_available_replicas
  end
end
