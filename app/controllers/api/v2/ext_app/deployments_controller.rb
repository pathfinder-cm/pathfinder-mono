class Api::V2::ExtApp::DeploymentsController < Api::V2::ExtApp::BaseController
  def bulk_apply
    ActiveRecord::Base.transaction do
      bulk_apply_params[:deployments].each do |deployment|
        deployment[:cluster] = Cluster.find_by!(name: deployment.delete(:cluster_name))
        Deployment.create(deployment)
      end
    end
  end

  private
  def bulk_apply_params
    params.require(:deployments)
    params.permit(deployments: [
      :cluster_name, :name, :count, definition: {}
    ])
  end
end
