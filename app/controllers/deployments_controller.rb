require 'json'

class DeploymentsController < ApplicationController
  before_action :authenticate_user!

  # GET /containers/new
  def new
    @cluster = Cluster.find(params[:cluster_id])
    @deployment = Deployment.new(cluster_id: @cluster.id)
  end

  #POST /containers/
  def create
    @cluster = Cluster.find_by(name: deployment_params[:deployments][0][:cluster_name])
    
    @deployment = bulk_apply

    respond_to do |format|
      if @deployment
        format.html { redirect_to cluster_path(@cluster), notice: 'Deployment was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
    def deployment_params
      params.require(:deployments)
      params.permit(deployments: [
      :cluster_name, :name, :count, :definition
    ])
    end

    def bulk_apply
      ActiveRecord::Base.transaction do
        deployment_params[:deployments].each do |bulk_params|
          cluster = Cluster.find_by!(name: bulk_params.delete(:cluster_name))
          deployment = Deployment.find_or_initialize_by(cluster: cluster, name: bulk_params[:name])
          deployment.assign_attributes(bulk_params)
          deployment.save!
        end
      end
    end
end
