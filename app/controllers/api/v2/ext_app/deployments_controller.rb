class Api::V2::ExtApp::DeploymentsController < Api::V2::ExtApp::BaseController
  def batch
    ActiveRecord::Base.transaction do
      bulk_apply_params[:deployments].each do |deployment_params|
        cluster = Cluster.find_by!(name: deployment_params.delete(:cluster_name))
        deployment = Deployment.find_or_initialize_by(cluster: cluster, name: deployment_params[:name])
        deployment.assign_attributes(deployment_params)
        deployment.save!
      end
    end
  end

  def index_containers
    cluster = Cluster.find_by!(name: params[:cluster_name])
    deployment = cluster.deployments.find_by!(name: params[:name])
    payload = {}
    payload[:containers] = deployment.managed_containers.map{|container| ::Api::V2::ExtApp::ContainerSerializer.new(container).to_h[:data]}

    render json: payload
  end

  private
  def bulk_apply_params
    params.require(:deployments)
    params.permit(deployments: [
      :cluster_name, :name, :desired_num_replicas, :min_available_replicas, definition: {}
    ])
  end
end
