class ::Api::V1::ExtApp::NodesController < ::Api::V1::ExtApp::BaseController

  # GET /
  def index
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @nodes = @cluster.nodes
    render json: ::Api::V1::ExtApp::NodeSerializer.new(@nodes).to_h
  end

  # GET /hostname
  def show
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @node = @cluster.nodes.find_by!(hostname: params[:hostname])
    render json: ::Api::V1::ExtApp::NodeSerializer.new(@node).to_h
  end
end
