class ::Api::V1::LookupsController < ::Api::BaseController
  skip_before_action :authenticate_by_access_token!, only: [:index, :ping]

  # GET /lookup
  # Retrieve all global lookups
  def index
    lookup = {}
    render json: ::Api::V1::LookupSerializer.new(object: lookup).to_h
  end

  # GET /ping
  # Ping the application
  def ping
    render json: {
      message: "OK",
      time: DateTime.current.strftime("%Q")
    }
  end
end
