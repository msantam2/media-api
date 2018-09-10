Rails.application.routes.draw do
  namespace :api do
    resources :movies, only: [:show]
    resources :shows,  only: [:show] 
  end
end
