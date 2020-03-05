require 'json'

class DeploymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_deployment, only: [:edit, :update]

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
    cluster = Cluster.find_by(name: deployment_create_params.delete(:cluster_name))
    deployment_create_params[:cluster] = cluster

    @deployment = Deployment.new
    begin
      deployment_create_params[:definition] = JSON.parse(deployment_create_params[:definition])
    rescue JSON::ParserError
        @deployment.errors.add(:definition, "Should be valid JSON")
        render :new
        return
    end
    
    @deployment.assign_attributes(deployment_create_params)
    respond_to do |format|
      if @deployment.save
        format.html { redirect_to cluster_path(cluster), notice: 'Deployment was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # GET /deployments/1/edit
  def edit
    @definition = @deployments[:definition].to_json
  end

  # PATCH/PUT /deployments/1
  def update
    deployment_update_params = deployment_params
    cluster = Cluster.find_by(name: deployment_update_params.delete(:cluster_name))

    deployment_update_params[:cluster] = cluster
    begin
      deployment_update_params[:definition] = JSON.parse(deployment_update_params[:definition])
    rescue JSON::ParserError
      @deployments.errors.add(:definition, "Should be valid JSON")
      render :edit
      return
    end

    @deployments.assign_attributes(deployment_update_params)
    respond_to do |format|
      if @deployments.save
        format.html { redirect_to cluster_path(cluster), notice: 'Deployment was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    def set_deployment
      @deployments = Deployment.find(params[:id])
    end

    def deployment_params
      params.require(:deployments).permit(:cluster_name, :name, :count, :definition)
    end
end
