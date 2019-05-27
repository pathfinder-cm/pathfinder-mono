class ::Api::V2::Node::ContainersController < ::Api::V2::Node::BaseController
  # GET /scheduled
  # Get all scheduled containers within a particular node
  def scheduled
    @containers = current_node.containers.
      where(status: [
        ::Container.statuses[:scheduled],
        ::Container.statuses[:schedule_deletion],
      ]).
      order(Arel.sql 'CASE WHEN status = \'SCHEDULE_DELETION\' THEN 1 WHEN status = \'SCHEDULED\' THEN 2 END').
      order('last_status_update_at ASC')
    render json: ::Api::V2::Node::ContainerSerializer.new(@containers).to_h
  end

  # POST /ipaddress
  def update_ipaddress
    @container = current_node.containers.exists.find_by(hostname: params[:hostname])
    @container.update!(ipaddress: params[:ipaddress])
    render json: ::Api::V2::Node::ContainerSerializer.new(@container).to_h
  end

  # POST /mark_provisioned
  # Mark container as provisioned
  def mark_provisioned
    @container = current_node.containers.exists.find_by(
      hostname: params[:hostname],
      status: 'SCHEDULED'
    )
    @container.update_status('PROVISIONED')
    render json: ::Api::V2::Node::ContainerSerializer.new(@container).to_h
  end

  # POST /mark_provision_error
  # Mark container as provision_error
  def mark_provision_error
    @container = current_node.containers.exists.find_by(
      hostname: params[:hostname],
      status: 'SCHEDULED'
    )
    @container.update_status('PROVISION_ERROR')
    render json: ::Api::V2::Node::ContainerSerializer.new(@container).to_h
  end

  # POST /mark_deleted
  # Mark container as deleted
  def mark_deleted
    @container = current_node.containers.exists.find_by(
      hostname: params[:hostname],
      status: 'SCHEDULE_DELETION'
    )
    @container.update_status('DELETED')
    render json: ::Api::V2::Node::ContainerSerializer.new(@container).to_h
  end
end
