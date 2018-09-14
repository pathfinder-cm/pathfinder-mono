class ::Api::V1::Node::RegistrationsController < ::Api::V1::Node::BaseController
  skip_before_action :authenticate_by_auth_token!
  before_action :set_cluster

  # GET /register
  # Register node into cluster
  def register
    raise UnauthorizedException if !@cluster.authenticate(params[:password])

    # Find or create the node
    @node = @cluster.nodes.find_by(hostname: params[:node_hostname])
    if @node.nil?
      @node = @cluster.nodes.create!(
        hostname: params[:node_hostname],
        ipaddress: (params[:node_ipaddress].blank?) ? request.remote_ip : params[:node_ipaddress]
      )
    end

    # Generate new authentication token
    authentication_token = @node.refresh_authentication_token

    # Render the response
    attrs = {authentication_token: authentication_token}
    render json: ::Api::V1::Node::RegistrationSerializer.new(
      @node, attrs: attrs).to_h
  end

  private
    def set_cluster
      @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    end
end
