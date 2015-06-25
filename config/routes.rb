Rails.application.routes.draw do
  get 'shopping_cart/add_to_cart'

  get 'shopping_cart/remove_from_cart'

  resources :credit_cards
  resources :items
  resources :activities

  devise_for :users

  get  '/buy',  	  to: 'items#buy',  			  as: 'buy_items'
  get  '/sell', 	  to: 'items#sell', 			  as: 'sell_items'
  post '/add_cards', to: 'credit_cards#process_bin', as: 'process_bin'

  root 'activities#index'
end
