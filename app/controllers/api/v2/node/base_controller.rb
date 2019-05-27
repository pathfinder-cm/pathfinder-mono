class ::Api::V2::Node::BaseController < ::Api::BaseController
  before_action :authenticate_by_auth_token!

  def authenticate_by_auth_token!
    cluster = ::Cluster.find_by(name: params[:cluster_name])
    @current_node = cluster.get_node_by_authentication_token(fetch_authentication_token) if cluster
    raise ::UnauthorizedException if @current_node.nil?
  end

  def current_node
    @current_node
  end

  private
    def fetch_authentication_token
      request.headers["X-Auth-Token"]
    end
end
