class Api::V2::ExtApp::DeploymentsController < Api::V2::ExtApp::BaseController
  def bulk_apply
    ActiveRecord::Base.transaction do
      bulk_apply_params[:deployments].each do |deployment_params|
        cluster = Cluster.find_by!(name: deployment_params.delete(:cluster_name))
        deployment = Deployment.find_or_initialize_by(cluster: cluster, name: deployment_params[:name])
        deployment.assign_attributes(deployment_params)
        deployment.save!
      end
    end
  end

  def list_containers
    deployment = Deployment.find_by(name: params[:name])
    render json: ::Api::V2::ExtApp::DeploymentSerializer.new(deployment).to_h
  end

  private
  def bulk_apply_params
    params.require(:deployments)
    params.permit(deployments: [
      :cluster_name, :name, :count, :min_available_count, definition: {}
    ])
  end
end
