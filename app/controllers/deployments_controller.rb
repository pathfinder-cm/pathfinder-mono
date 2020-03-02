require 'json'

class DeploymentsController < ApplicationController
  before_action :authenticate_user!

  # GET /deployments
  def index
    @deployments = Deployment.all
  end

  # GET /deployments/new
  def new
    if params[:cluster_id]
      @cluster = Cluster.find(params[:cluster_id])
      @deployment = Deployment.new(cluster_id: @cluster.id)
    else
      @deployment = Deployment.new
    end
  end

  #POST /deployments/
  def create
    deployment_create_params = deployment_params
    cluster = Cluster.find_by!(name: deployment_create_params.delete(:cluster_name))
    deployment = Deployment.find_or_initialize_by(cluster: cluster, name: deployment_create_params[:name])
    deployment.assign_attributes(deployment_create_params)
    deployment.save!

    respond_to do |format|
      if deployment
        format.html { redirect_to cluster_path(cluster), notice: 'Deployment was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
    def deployment_params
      params.require(:deployments).permit(:cluster_name, :name, :count, :definition)
    end
end
