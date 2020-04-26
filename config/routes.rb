Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'register', to: 'devise/registrations#new'
    get 'login', to: 'devise/sessions#new'
    post 'login', to: 'devise/sessions#create'
    post 'logout', to: 'devise/sessions#destroy'
  end

  resources :users
  resources :ext_apps, except: :destroy
  resources :clusters, except: :destroy,
    defaults: { format: :html } do
      member do
        get 'deployments' => 'clusters#show_deployments'
        get 'containers' => 'clusters#show_containers'
      end
    end
  resources :nodes, only: :show do
    member do
      post 'cordon' => 'nodes#cordon'
    end
  end
  resources :containers, only: [:new, :create] do
    member do
      post 'schedule_deletion' => 'containers#schedule_deletion'
      post 'reschedule' => 'containers#reschedule'
    end
  end
  resources :sources, except: :destroy
  resources :remotes, except: :destroy
  resources :deployments, except: :destroy

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get '/lookup' => 'lookups#index'
      get '/ping' => 'lookups#ping'

      namespace :ext_app do
        resources :containers, only: [:index] do
          collection do
            get ':hostname' => 'containers#show'
            post '' => 'containers#create'
            post ':hostname/schedule_deletion' =>
              'containers#schedule_deletion'
            post ':hostname/reschedule' => 'containers#reschedule'
          end
        end

        resources :nodes, only: [:index] do
          collection do
            get ':hostname' => 'nodes#show'
          end
        end
      end

      namespace :node do
        post 'register' => 'registrations#register'

        resources :containers, only: [] do
          collection do
            get 'scheduled' => 'containers#scheduled'
            post 'ipaddress' => 'containers#update_ipaddress'
            post 'mark_provisioned' => 'containers#mark_provisioned'
            post 'mark_provision_error' => 'containers#mark_provision_error'
            post 'mark_deleted' => 'containers#mark_deleted'
          end
        end

        resources :nodes, only: [] do
          collection do
            post 'store_metrics' => 'nodes#store_metrics'
          end
        end
      end
    end

    namespace :v2 do
      namespace :ext_app do
        resources :containers, only: [:index] do
          collection do
            get ':hostname' => 'containers#show'
            post '' => 'containers#create'
            post ':hostname/schedule_deletion' =>
              'containers#schedule_deletion'
            post ':hostname/reschedule' => 'containers#reschedule'
            post ':hostname/rebootstrap' => 'containers#rebootstrap'
            patch ':hostname/update' => 'containers#update'
          end
        end

        resources :deployments, only: [] do
          collection do
            get ':name/containers' => 'deployments#index_containers'
            post 'batch' => 'deployments#batch'
          end
        end
      end

      namespace :node do
        resources :containers, only: [] do
          collection do
            get 'scheduled' => 'containers#scheduled'
            get 'bootstrap_scheduled' => 'containers#bootstrap_scheduled'
            post 'ipaddress' => 'containers#update_ipaddress'
            post 'mark_provisioned' => 'containers#mark_provisioned'
            post 'mark_provision_error' => 'containers#mark_provision_error'
            post 'mark_bootstrap_started' => 'containers#mark_bootstrap_started'
            post 'mark_bootstrapped' => 'containers#mark_bootstrapped'
            post 'mark_bootstrap_error' => 'containers#mark_bootstrap_error'
            post 'mark_deleted' => 'containers#mark_deleted'
          end
        end
      end
    end
  end

  root to: 'clusters#index'
end
