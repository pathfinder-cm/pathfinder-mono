class ::Api::V1::Node::ContainersController < ::Api::BaseController
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
