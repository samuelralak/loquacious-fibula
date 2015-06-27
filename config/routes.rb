Rails.application.routes.draw do
  resources :credit_cards
  resources :items
  resources :activities

  devise_for :users

  get  '/buy',  	   to: 'items#buy',  			         as: 'buy_items'
  get  '/sell', 	   to: 'items#sell', 			         as: 'sell_items'
  get  '/view_cart', to: 'shopping_cart#view_cart',  as: 'view_cart'

  post '/add_cards',        to: 'credit_cards#process_bin',       as: 'process_bin'
  post '/add_to_cart',      to: 'shopping_cart#add_to_cart',      as: 'add_to_cart'
  post '/remove_from_cart', to: 'shopping_cart#remove_from_cart', as: 'remove_from_cart'

  root 'activities#index'
end
