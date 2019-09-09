class SourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_source, only: [:show, :edit, :update]

  # GET /ext_apps
  def index
    @sources = Source.all
  end

  # GET /remotes/1
  def show
  end

  # GET /sources/new
  def new
    @source = Source.new
  end

  # GET /remotes/1/edit
  def edit
  end

  # PATCH/PUT /ext_apps/1
  def update
    @source = Source.find(params[:id])

    if @source.update(source_params)
      redirect_to @source
    else
      render 'edit'
    end
  end

  # POST /sources
  def create
    @source = Source.create(source_params)

    respond_to do |format|
      if @source.errors.none?
        format.html { redirect_to source_path(@source.id), notice: 'Source was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
    def set_source
      @source = Source.find(params[:id])
    end

    def source_params
      params.require(:source).permit(
        :source_type,
        :mode,
        :remote_id,
        :fingerprint,
        :alias
      )
    end
end
