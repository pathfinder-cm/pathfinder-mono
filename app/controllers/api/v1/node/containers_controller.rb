class ::Api::V1::Node::ContainersController < ::Api::BaseController
  # GET /scheduled
  # Get all scheduled containers within a particular node
  def scheduled
    @node = Node.find_by(hostname: params[:node_hostname])
    @containers = @node.containers.
      where(status: Container.statuses[:scheduled]).
      order('last_status_update_at ASC')
    render json: ::Api::V1::Node::ContainerSerializer.new(@containers).to_h
  end

  # POST /provision
  # Mark container as provisioned
  def provision
    @container = Container.find_by(provision_params)
    @container.update_status('PROVISIONED')
    render json: ::Api::V1::Node::ContainerSerializer.new(@container).to_h
  end

  private
    def provision_params
      params.require(:data).permit(
        :node_id,
        :hostname
      )
    end
end
