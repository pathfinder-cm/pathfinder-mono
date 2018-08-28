class ContainersController < ApplicationController
  before_action :authenticate_user!

  # GET /containers/new
  def new
    @cluster = Cluster.find(params[:cluster_id])
    @container = Container.new(cluster_id: @cluster.id)
  end

  # POST /containers
  def create
    @container = Container.new(container_params)

    respond_to do |format|
      if @container.save
        format.html { redirect_to cluster_path(@container.cluster), notice: 'Container was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # POST /schedule_deletion
  def schedule_deletion
    @container = Container.find(params[:id])

    respond_to do |format|
      if @container.update_status('SCHEDULE_DELETION')
        format.html { redirect_to cluster_path(@container.cluster), notice: 'Container was scheduled for deletion.' }
      else
        format.html { redirect_to cluster_path(@container.cluster), notice: 'Error when scheduling container for deletion.' }
      end
    end
  end

  private
    def container_params
      params.require(:container).permit(
        :cluster_id,
        :hostname,
        :image
      )
    end
end
