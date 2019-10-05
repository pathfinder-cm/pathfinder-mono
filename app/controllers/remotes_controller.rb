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

  # POST /remotes
  def create
    @remote = Remote.create(remote_params)

    respond_to do |format|
      if @remote.save
        format.html { redirect_to remote_path(@remote.id), notice: 'Remote was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # GET /remotes/1/edit
  def edit
  end

  # PATCH/PUT /remotes/1
  def update
    respond_to do |format|
      if @remote.update(remote_params)
        format.html { redirect_to @remote, notice: 'Remote was successfully updated.' }
      else
        format.html { render :edit }
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
