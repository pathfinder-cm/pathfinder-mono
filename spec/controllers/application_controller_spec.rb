require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def index
      render plain: "test", status: 200
    end
  end

  before do
    @routes.draw do
      get '/anonymous/index' => 'fulcrum/application#index'
    end
  end

  before(:each) do
    @request.host = "example.com"
  end
end
