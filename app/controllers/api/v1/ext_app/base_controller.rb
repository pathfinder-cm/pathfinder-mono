class ::Api::V1::ExtApp::BaseController < ::Api::BaseController
  before_action :authenticate_by_access_token!

  def authenticate_by_access_token!
    unless ExtApp.valid_access_token?(fetch_access_token)
      raise ::UnauthorizedException
    end
  end

  private
    def fetch_access_token
      request.headers["X-Auth-Token"]
    end
end
