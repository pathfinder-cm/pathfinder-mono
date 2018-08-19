class ClustersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cluster, only: [:show, :edit, :update, :destroy]

  # GET /clusters
  def index
    @clusters = Cluster.all
  end

  # GET /clusters/1
  def show
    @nodes = @cluster.nodes
  end

  # GET /clusters/new
  def new
    @cluster = Cluster.new
  end

  # POST /clusters
  def create
    @cluster = Cluster.new(cluster_params)

    respond_to do |format|
      if @cluster.save
        format.html { redirect_to clusters_path, notice: 'Cluster was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # GET /clusters/1/edit
  def edit
  end

  # PATCH/PUT /clusters/1
  def update
    respond_to do |format|
      if @cluster.update(cluster_params)
        format.html { redirect_to @cluster, notice: 'Cluster was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    def set_cluster
      @cluster = Cluster.find(params[:id])
    end

    def cluster_params
      params.require(:cluster).permit(
        :name
      )
    end
end
