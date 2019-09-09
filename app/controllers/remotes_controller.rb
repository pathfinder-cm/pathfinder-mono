class RemotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_remote, only: [:show, :edit, :update]

  # GET /remotes
  def index
    @remotes = Remote.all
  end

  # GET /remotes/1
  def show
  end

  # GET /remotes/new
  def new
    @remote = Remote.new
  end

  # GET /remotes/1/edit
  def edit
  end

  # PATCH/PUT /ext_apps/1
  def update
    @remote = Remote.find(params[:id])

    if @remote.update(remote_params)
      redirect_to @remote
    else
      render 'edit'
    end
  end

  # POST /remotes
  def create
    @remote = Remote.create(remote_params)

    respond_to do |format|
      if @remote.errors.none?
        format.html { redirect_to remote_path(@remote.id), notice: 'Remote was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
    def set_remote
      @remote = Remote.find(params[:id])
    end

    def remote_params
      params.require(:remote).permit(
        :name,
        :server,
        :protocol,
        :auth_type,
        :certificate
      )
    end
end
