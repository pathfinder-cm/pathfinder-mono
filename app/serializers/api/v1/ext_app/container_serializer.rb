class ::Api::V1::ExtApp::ContainerSerializer < ::Api::V1::BaseSerializer
  def data
    if @object.is_a? Enumerable
      {
        total_server_items: @total_server_items,
        items: @object.map{ |container| serialize(container) }
      }
    else
      serialize(@object)
    end
  end

  def serialize(container)
    {
      id: container.id,
      hostname: container.hostname,
      ipaddress: container.ipaddress,
      image: container.image,
      node_name: container.node&.hostname,
      status: container.status,
      last_status_update_at: container.last_status_update_at,
    }
  end
end
