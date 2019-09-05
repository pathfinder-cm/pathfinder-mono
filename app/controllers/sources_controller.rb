class SourcesController < ApplicationController
  before_action :authenticate_user!

  # GET /ext_apps
  def index
    @sources = Source.all
  end

  # GET /sources/new
  def new
    @source = Source.new
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
