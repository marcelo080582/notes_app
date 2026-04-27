Rails.application.routes.draw do
  post "/register", to: "auth#register"
  post "/login", to: "auth#login"

  namespace :api do
    namespace :v1 do
      resources :notes, only: [:index, :create, :update, :destroy]
    end
  end
end