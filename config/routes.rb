Rails.application.routes.draw do
  resources :credit_cards
  resources :items
  resources :activities

  devise_for :users

  get  '/buy',  	   to: 'items#buy',  			   as: 'buy_items'
  get  '/sell', 	   to: 'items#sell', 			   as: 'sell_items'
  post '/process_bin', to: 'credit_cards#process_bin', as: 'process_bin'

  root 'activities#index'
end
