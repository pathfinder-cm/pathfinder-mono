class DeploymentsController < ApplicationController
  before_action :authenticate_user!

  # GET /deployments
  def index
    @deployments = Deployment.all
  end
end
