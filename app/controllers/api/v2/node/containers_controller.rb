class ::Api::V2::Node::ContainersController < ::Api::V2::Node::BaseController
  # GET /scheduled
  # Get all scheduled containers within a particular node
  def scheduled
    @containers = current_node.containers.
      where(status: [
        ::Container.statuses[:scheduled],
        ::Container.statuses[:schedule_deletion],
        ::Container.statuses[:schedule_relocation],
      ]).
      order(Arel.sql 'CASE WHEN status = \'SCHEDULE_DELETION\' THEN 1 WHEN status = \'SCHEDULED\' THEN 2 END').
      order('last_status_update_at ASC')
    render json: ::Api::V2::Node::ContainerSerializer.new(@containers).to_h
  end

  # GET /bootstrap_scheduled
  # Get all bootstrap scheduled containers within a particular node
  def bootstrap_scheduled
    @containers = current_node.containers.
      where(status: ::Container.statuses[:provisioned])
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
      status: ['SCHEDULED', 'RELOCATE_STARTED']
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

  # POST /mark_bootstrap_started
  # Mark container as bootstrap_started
  def mark_bootstrap_started
    @container = current_node.containers.exists.find_by(
      hostname: params[:hostname],
      status: 'PROVISIONED'
    )
    @container.update_status('BOOTSTRAP_STARTED')
    render json: ::Api::V2::Node::ContainerSerializer.new(@container).to_h
  end

  # POST /mark_bootstrapped
  # Mark container as bootstrapped
  def mark_bootstrapped
    @container = current_node.containers.exists.find_by(
      hostname: params[:hostname],
      status: ['BOOTSTRAP_STARTED', 'RELOCATE_STARTED']
    )
    @container.update_status('BOOTSTRAPPED')
    render json: ::Api::V2::Node::ContainerSerializer.new(@container).to_h
  end

  # POST /mark_bootstrap_error
  # Mark container as mark_bootstrap_error
  def mark_bootstrap_error
    @container = current_node.containers.exists.find_by(
      hostname: params[:hostname],
      status: ['PROVISIONED', 'BOOTSTRAP_STARTED']
    )
    @container.update_status('BOOTSTRAP_ERROR')
    render json: ::Api::V2::Node::ContainerSerializer.new(@container).to_h
  end

  # POST /mark_relocate_started
  # Mark container as relocate_started
  def mark_relocate_started
    @container = current_node.containers.exists.find_by(
      hostname: params[:hostname],
      status: 'SCHEDULE_RELOCATION'
    )
   @container.update_status('RELOCATE_STARTED')
    render json: ::Api::V2::Node::ContainerSerializer.new(@container).to_h
  end

  # POST /mark_relocate_error
  # Mark container as relocate_error
  def mark_relocate_started
    @container = current_node.containers.exists.find_by(
      hostname: params[:hostname],
      status: 'SCHEDULE_STARTED'
    )
   @container.update_status('RELOCATE_ERROR')
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
