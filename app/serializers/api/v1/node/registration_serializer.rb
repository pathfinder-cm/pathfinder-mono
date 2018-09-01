class ::Api::V1::Node::RegistrationSerializer < ::Api::V1::BaseSerializer
  def data
    serialize(@object)
  end

  def serialize(node)
    {
      id: node.id,
      cluster_id: node.cluster_id,
      cluster_name: node.cluster.name,
      hostname: node.hostname,
      authentication_token: @attrs[:authentication_token],
      authentication_token_generated_at: node.authentication_token_generated_at
    }
  end
end
