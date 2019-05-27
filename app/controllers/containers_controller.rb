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

  # POST /reschedule
  def reschedule
    @container = Container.find(params[:id])
    @container.update_status('SCHEDULE_DELETION')
    @new_container = Container.new(
      cluster_id: @container.cluster_id,
      hostname: @container.hostname,
      image_alias: @container.image_alias,
      image_server: @container.image_server,
      image_protocol: @container.image_protocol
    )
    respond_to do |format|
      if @new_container.save
        format.html { redirect_to cluster_path(@new_container.cluster), notice: 'Container was rescheduled.' }
      else
        format.html { redirect_to cluster_path(@new_container.cluster), notice: 'Error when rescheduling container.' }
      end
    end
  end

  private
    def container_params
      params.require(:container).permit(
        :cluster_id,
        :hostname,
        :image_alias,
        :image_server,
        :image_protocol
      )
    end
end
