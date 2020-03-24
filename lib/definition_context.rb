class DefinitionContext
  def initialize(deployment, container_hostname)
    @deployment = deployment
    @container_hostname = container_hostname
  end

  def passthrough(value: )
    value
  end

  def deployment_ip_addresses(deployment_name: )
    containers = Deployment.find_by(name: deployment_name).desired_replicas
    containers.pluck(:ipaddress).compact
  end

  def container_id
    parse_container_id(@container_hostname)
  end

  def deployment_host_sequences(host: , self_host: "0.0.0.0")
    @deployment.container_names.map do |name|
      if @container_hostname == name
        self_host
      else
        "#{parse_container_id(name)}.#{host}"
      end
    end
  end

  private
  def parse_container_id(hostname)
    hostname[(@deployment.name.length + 1)..-1].to_i
  end
end
