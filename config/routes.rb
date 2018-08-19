Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'register', to: 'devise/registrations#new'
    get 'login', to: 'devise/sessions#new'
    post 'login', to: 'devise/sessions#create'
    post 'logout', to: 'devise/sessions#destroy'
  end

  resources :users
  resources :clusters, except: :destroy
  resources :nodes, only: :show
  resources :containers, only: [:new, :create]

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get '/lookup' => 'lookups#index'
      get '/ping' => 'lookups#ping'
    end
  end

  root to: 'clusters#index'
end
