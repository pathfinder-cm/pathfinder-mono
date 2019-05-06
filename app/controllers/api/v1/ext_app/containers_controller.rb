class ::Api::V1::ExtApp::ContainersController < ::Api::V1::ExtApp::BaseController

  # GET /
  def index
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @containers = @cluster.containers.exists
    render json: ::Api::V1::ExtApp::ContainerSerializer.new(@containers).to_h
  end

  # GET /:name
  def show
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @container = @cluster.containers.exists.find_by(hostname: params[:hostname])
    render json: ::Api::V1::ExtApp::ContainerSerializer.new(@container).to_h
  end

  # POST /
  def create
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @container = @cluster.containers.new(container_params)
    @container.save!
    render json: ::Api::V1::ExtApp::ContainerSerializer.new(@container).to_h
  end

  # POST /schedule_deletion
  def schedule_deletion
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @container = @cluster.containers.exists.find_by(hostname: params[:hostname])
    @container.update_status('SCHEDULE_DELETION')
    render json: ::Api::V1::ExtApp::ContainerSerializer.new(@container).to_h
  end

  def reschedule
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @container = @cluster.containers.exists.find_by(
      hostname: params[:hostname]
    )
    @container.update_status('SCHEDULE_DELETION')
    @new_container = Container.new(
      cluster_id: @container.cluster_id,
      hostname:   @container.hostname,
      image_alias:      @container.image_alias,
      image_server: @container.image_server,
      image_protocol: @container.image_protocol
    )
    @new_container.save!
    render json: ::Api::V1::ExtApp::ContainerSerializer.new(@new_container).to_h
  end

  private
    def container_params
      params.require(:container).permit(
        :hostname,
        :image_alias,
        :image_server,
        :image_protocol
      )
    end
end
