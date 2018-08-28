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
  resources :containers, only: [:new, :create, :destroy] do
    member do
      post 'schedule_deletion' => 'containers#schedule_deletion'
    end
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get '/lookup' => 'lookups#index'
      get '/ping' => 'lookups#ping'

      namespace :node do
        resources :containers, only: [] do
          collection do
            get 'scheduled' => 'containers#scheduled'
            post 'provision' => 'containers#provision'
            post 'provision_error' => 'containers#provision_error'
          end
        end
      end
    end
  end

  root to: 'clusters#index'
end
