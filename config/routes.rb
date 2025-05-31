Rails.application.routes.draw do
  root "home#index", controller: "HomeController"
  resources :movies
  resource :session
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create", as: :create_session
  delete "logout" => "sessions#destroy", as: :logout
  get "sign-up" => "users#new", as: :signup
  post "sign-up" => "users#create", as: :create_user

  resources :users, only: [ :create ] do
    resources :votes, only: [ :create, :update, :destroy ]
  end

  resources :passwords, param: :token
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
