class ::Api::V2::ExtApp::DeploymentSerializer < ::Api::V2::BaseSerializer
  def data
    if @object.is_a? Enumerable
      {
        total_server_items: @total_server_items,
        items: @object.map{ |deployment| serialize(deployment) }
      }
    else
      serialize(@object)
    end
  end

  def serialize(deployment)
    {
      name: deployment.name,
      count: deployment.count,
      definition: deployment.definition,
      containers: deployment.managed_containers.map{|container| serialize_container(container)}
    }
  end

  def serialize_container(container)
    {
      hostname: container.hostname,
      ipaddress: container.ipaddress,
      source: {
        id: container.source&.id,
        source_type: container.source&.source_type,
        mode: container.source&.mode,
        remote: {
          id: container.source&.remote&.id,
          name: container.source&.remote&.name,
          server: container.source&.remote&.server,
          protocol: container.source&.remote&.protocol,
          auth_type: container.source&.remote&.auth_type
        },
        fingerprint: container.source&.fingerprint,
        alias: container.source&.alias
      },
      bootstrappers: container.bootstrappers,
      status: container.status,
      last_status_update_at: container.last_status_update_at,
    }
  end
end
