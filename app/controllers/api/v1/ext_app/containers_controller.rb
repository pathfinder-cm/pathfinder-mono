class ::Api::V1::ExtApp::ContainersController < ::Api::BaseController
  # GET /:name
  def show
    @cluster = ::Cluster.find_by!(name: params[:cluster_name])
    @container = @cluster.containers.find_by(hostname: params[:hostname])
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
    @container = @cluster.containers.find_by(hostname: params[:hostname])
    @container.update_status('SCHEDULE_DELETION')
    render json: ::Api::V1::ExtApp::ContainerSerializer.new(@container).to_h
  end

  private
    def container_params
      params.require(:container).permit(
        :hostname,
        :image
      )
    end
end
