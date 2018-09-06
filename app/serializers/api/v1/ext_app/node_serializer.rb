class ::Api::V1::ExtApp::NodeSerializer < ::Api::V1::BaseSerializer
  def data
    if @object.is_a? Enumerable
      {
        total_server_items: @total_server_items,
        items: @object.map{ |node| serialize(node) }
      }
    else
      serialize(@object)
    end
  end

  def serialize(node)
    {
      id: node.id,
      hostname: node.hostname,
      ipaddress: node.ipaddress,
      created_at: node.created_at,
      mem_free_mb: node.mem_free_mb,
      mem_used_mb: node.mem_used_mb,
      mem_total_mb: node.mem_total_mb,
    }
  end
end
