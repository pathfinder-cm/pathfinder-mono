class DefinitionContext
  attr_reader :container_id

  def initialize(deployment, container_hostname)
    @deployment = deployment
    @container_hostname = container_hostname

    @container_id = container_hostname[(deployment.name.length + 1)..-1].to_i
  end

  def passthrough(value: )
    value
  end

  def deployment_ip_addresses(deployment_name: )
    containers = Deployment.find_by(name: deployment_name).wanted_existing_containers
    containers.pluck(:ipaddress).compact
  end
end
