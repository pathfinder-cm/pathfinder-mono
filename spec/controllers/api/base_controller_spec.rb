require 'rails_helper'

RSpec.describe ::Api::BaseController do
  controller do
    skip_before_action :authenticate_by_access_token!

    def index
      render plain: "test", status: 200
    end

    def standard_error
      raise ::StandardError
    end

    def runtime_error
      raise ::RuntimeError
    end

    def statement_invalid
      raise ::ActiveRecord::StatementInvalid
    end

    def record_invalid
      raise ::ActiveRecord::RecordInvalid, User.new
    end

    def record_not_found
      raise ::ActiveRecord::RecordNotFound
    end

    def unauthorized_exception
      raise UnauthorizedException
    end
  end

  before do
    @routes.draw do
      get '/anonymous/index' => 'api/base#index'
      get '/anonymous/standard_error' => 'api/base#standard_error'
      get '/anonymous/runtime_error' => 'api/base#runtime_error'
      get '/anonymous/statement_invalid' => 'api/base#statement_invalid'
      get '/anonymous/record_invalid' => 'api/base#record_invalid'
      get '/anonymous/record_not_found' => 'api/base#record_not_found'
      get '/anonymous/unauthorized_exception' => 'api/base#unauthorized_exception'
    end
  end

  before(:each) do
    @request.host = "example.com"
  end

  describe "raise StandardError" do
    it "should return 500 if StandardError exception is raised" do
      get :standard_error
      expect(response.response_code).to eq 500
    end
  end

  describe "raise RuntimeError" do
    it "should return 500 if RuntimeError exception is raised" do
      get :runtime_error
      expect(response.response_code).to eq 500
    end
  end

  describe "raise ActiveRecord::StatementInvalid" do
    it "should return 500 if query statement is invalid" do
      get :statement_invalid
      expect(response.response_code).to eq 500
    end
  end

  describe "raise ActiveRecord::RecordInvalid" do
    it "should return 406 if system can't process the record" do
      get :record_invalid
      expect(response.response_code).to eq 406
    end
  end

  describe "raise ActiveRecord::RecordNotFound" do
    it "should return 404 if system can't find specified record" do
      get :record_not_found
      expect(response.response_code).to eq 404
    end
  end

  describe "raise UnauthorizedException" do
    it "should return 401 if UnauthorizedException exception is raised" do
      get :unauthorized_exception
      expect(response.response_code).to eq 401
    end
  end
end
