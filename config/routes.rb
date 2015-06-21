Rails.application.routes.draw do
  resources :credit_cards
  resources :items
  resources :activities

  devise_for :users

  get '/buy',  to: 'items#buy',  as: 'buy_items'
  get '/sell', to: 'items#sell', as: 'sell_items'

  root 'activities#index'
end
