Rails.application.routes.draw do
  resources :movies, only: [:show]
  resources :shows,  only: [:show] 
end
