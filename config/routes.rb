Rails.application.routes.draw do
  namespace :api do
    get "/search" => "search#index"
    resources :movies, only: [:show]
    resources :shows,  only: [:show]
  end
end
