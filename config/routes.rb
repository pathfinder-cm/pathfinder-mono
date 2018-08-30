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
  resources :containers, only: [:new, :create] do
    member do
      post 'schedule_deletion' => 'containers#schedule_deletion'
    end
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get '/lookup' => 'lookups#index'
      get '/ping' => 'lookups#ping'

      namespace :ext_app do
        resources :containers, only: [] do
          collection do
            get ':hostname' => 'containers#show'
            post '' => 'containers#create'
            post ':hostname/schedule_deletion' =>
              'containers#schedule_deletion'
          end
        end
      end

      namespace :node do
        resources :containers, only: [] do
          collection do
            get 'scheduled' => 'containers#scheduled'
            post 'ipaddress' => 'containers#update_ipaddress'
            post 'mark_provisioned' => 'containers#mark_provisioned'
            post 'mark_provision_error' => 'containers#mark_provision_error'
            post 'mark_deleted' => 'containers#mark_deleted'
          end
        end
      end
    end
  end

  root to: 'clusters#index'
end
