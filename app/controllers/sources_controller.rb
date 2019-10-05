class SourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_source, only: [:show, :edit, :update]

  # GET /sources
  def index
    @sources = Source.all
  end

  # GET /sources/1
  def show
  end

  # GET /sources/new
  def new
    @source = Source.new
  end

  # POST /sources
  def create
    @source = Source.create(source_params)

    respond_to do |format|
      if @source.save
        format.html { redirect_to source_path(@source.id), notice: 'Source was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # GET /sources/1/edit
  def edit
  end

  # PATCH/PUT /sources/1
  def update
    respond_to do |format|
      if @source.update(source_params)
        format.html { redirect_to @source, notice: 'Source was successfully updated.' }
      else
        format.html { render :edit }
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
