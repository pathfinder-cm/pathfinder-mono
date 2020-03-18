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
      desired_num_replicas: deployment.desired_num_replicas,
      definition: deployment.definition,
      containers: deployment.managed_containers.map{|container| ::Api::V2::ExtApp::ContainerSerializer.new(container).to_h[:data]}
    }
  end
end
