Rails.application.routes.draw do
  delete '/vehicles', to: "vehicles#destroy"
  resources :vehicles
end
