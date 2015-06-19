Rails.application.routes.draw do
  resources :activities

  devise_for :users
  root 'activities#index'
end
