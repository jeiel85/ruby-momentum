Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  namespace :admin do
    get "dashboard" => "dashboard#index"
    get "reports" => "dashboard#reports"
    patch "reports/:id/resolve" => "dashboard#resolve_report", as: :resolve_report
  end

  resources :posts do
    resources :reports, only: :create
    resources :comments, only: :create
    resource :like, only: [:create, :destroy]
    resource :bookmark, only: [:create, :destroy]
  end

  resources :bookmarks, only: :index

  resources :reports, only: [] do
    member do
      patch :resolve
    end
  end

  # Subscription routes
  resource :subscription, only: [:show, :create] do
    member do
      delete :cancel
    end
  end

  # Tip routes
  resources :tips, only: [:index, :create] do
    collection do
      post :webhook
    end
  end

  # User tips (tip a specific user)
  resources :users, only: [] do
    resources :tips, only: [:create]
  end

  root "posts#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
