class ::Api::V1::Node::ContainersController < ::Api::BaseController
  # GET /scheduled
  # Get all scheduled containers within a particular node
  def scheduled
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @node = @cluster.nodes.find_by!(hostname: params[:node_hostname])
    @containers = @node.containers.
      where(status: [
        ::Container.statuses[:scheduled], 
        ::Container.statuses[:schedule_deletion],
      ]).
      order('last_status_update_at ASC')
    render json: ::Api::V1::Node::ContainerSerializer.new(@containers).to_h
  end

  # POST /provision
  # Mark container as provisioned
  def provision
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @node = @cluster.nodes.find_by!(hostname: params[:node_hostname])
    @container = @node.containers.find_by(hostname: params[:hostname])
    @container.update_status('PROVISIONED')
    render json: ::Api::V1::Node::ContainerSerializer.new(@container).to_h
  end

  # POST /provision_error
  # Mark container as provision_error
  def provision_error
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @node = @cluster.nodes.find_by!(hostname: params[:node_hostname])
    @container = @node.containers.find_by(hostname: params[:hostname])
    @container.update_status('PROVISION_ERROR')
    render json: ::Api::V1::Node::ContainerSerializer.new(@container).to_h
  end

  # POST /mark_deleted
  # Mark container as deleted
  def mark_deleted
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @node = @cluster.nodes.find_by!(hostname: params[:node_hostname])
    @container = @node.containers.find_by(hostname: params[:hostname])
    @container.update_status('DELETED')
    render json: ::Api::V1::Node::ContainerSerializer.new(@container).to_h
  end
end
