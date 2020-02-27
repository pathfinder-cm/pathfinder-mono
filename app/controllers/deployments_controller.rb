class DeploymentsController < ApplicationController
  before_action :authenticate_user!

  # GET /containers/new
  def new
    @cluster = Cluster.find(params[:cluster_id])
    @deployment = Deployment.new(cluster_id: @cluster.id)
  end
end
