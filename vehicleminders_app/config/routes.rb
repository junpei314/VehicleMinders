Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: "vehicles#home"
  delete '/vehicles', to: "vehicles#destroy"
  get "/vehicles/new/:user_id", to: "vehicles#new"
  get "/vehicles/index/:user_id", to: "vehicles#index"
  post "/vehicles/upload/:user_id", to: "vehicles#upload"
  post "/vehicles/import/:user_id", to: "vehicles#import"
  get "/vehicles/select_columns/:user_id", to: "vehicles#select_columns"
  resources :vehicles
  get "/signup", to: "users#new"
  resources :users
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  get "/notifications/index/:vehicle_id", to: "notifications#index"
  resources :notifications
end
