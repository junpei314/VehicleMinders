Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: "users#home"
  delete '/vehicles', to: "vehicles#destroy"
  get "/vehicles/new/:user_id", to: "vehicles#new", as: 'new_vehicle_for_user'
  get "/vehicles/index/:user_id", to: "vehicles#index", as: 'vehicles_for_user'
  post "/vehicles/upload/:vehicle_id", to: "vehicles#upload"
  post "/vehicles/import/:vehicle_id", to: "vehicles#import"
  get "/vehicles/select_columns/:user_id", to: "vehicles#select_columns"
  resources :vehicles, param: :vehicle_id
  get "/signup", to: "users#new"
  resources :users, param: :user_id
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  get "/notifications/index/:vehicle_id", to: "notifications#index"
  get "/notifications/new/:vehicle_id", to: "notifications#new"
  resources :notifications, param: :notification_id
  get 'download_csv', to: 'users#download_csv'
end
