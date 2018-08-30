class ExtAppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ext_app, only: [:show, :edit, :update, :destroy]

  # GET /ext_apps
  def index
    @ext_apps = ExtApp.all
  end

  # GET /ext_apps/1
  def show
  end

  # GET /ext_apps/new
  def new
    @ext_app = ExtApp.new
  end

  # POST /ext_apps
  def create
    @ext_app = ExtApp.new(ext_app_params)
    access_token = SecureRandom.urlsafe_base64(48)
    @ext_app.access_token = access_token
    @ext_app.user_id = current_user.id

    respond_to do |format|
      if @ext_app.save
        format.html { redirect_to @ext_app, notice: 'ExtApp was successfully created.', flash: {access_token: access_token} }
      else
        format.html { render :new }
      end
    end
  end

  # GET /ext_apps/1/edit
  def edit
  end

  # PATCH/PUT /ext_apps/1
  def update
    respond_to do |format|
      if @ext_app.update(ext_app_params)
        format.html { redirect_to @ext_app, notice: 'ExtApp was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    def set_ext_app
      @ext_app = ExtApp.find(params[:id])
    end

    def ext_app_params
      params.require(:ext_app).permit(
        :name,
        :description,
      )
    end
end
