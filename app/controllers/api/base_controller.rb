class ::Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_by_access_token!

  def authenticate_by_access_token!
    unless ExtApp.valid_access_token?(fetch_access_token)
      raise ::UnauthorizedException
    end
  end

  # Handle StandardError
  rescue_from ::StandardError do |e|
    render json: ::Api::V1::Error::StandardErrorSerializer.new(e).to_h,
      status: 500 # Internal Server Error
  end

  # Handle RuntimeError
  rescue_from ::RuntimeError do |e|
    render json: ::Api::V1::Error::StandardErrorSerializer.new(e).to_h,
      status: 500 # Internal Server Error
  end

  # Handle ActiveRecord::StatementInvalid error
  rescue_from ::ActiveRecord::StatementInvalid do |e|
    render json: ::Api::V1::Error::StatementInvalidSerializer.new(e).to_h,
      status: 500 # Internal Server Error
  end

  # Handle ActiveRecord::RecordInvalid error
  rescue_from ::ActiveRecord::RecordInvalid do |e|
    render json: ::Api::V1::Error::RecordInvalidSerializer.new(e).to_h,
      status: 406 # unprocessable entity
  end

  # Handle ActiveRecord::RecordNotFound error
  rescue_from ::ActiveRecord::RecordNotFound do |e|
    render json: ::Api::V1::Error::RecordNotFoundSerializer.new(e).to_h,
      status: 404 # not found
  end

  # Handle 401 error
  rescue_from UnauthorizedException do |exception|
    e = StandardError.new("Unauthorized access")
    render json: ::Api::V1::Error::BaseSerializer.new(e).to_h,
      status: 401 # unauthorized
  end

  private
    def fetch_access_token
      request.headers["X-Auth-Token"]
    end
end
