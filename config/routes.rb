Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :items
  resources :activities
  resources :credit_cards

  resources :orders do
      resources :order_items
  end

  devise_for :users

  get  '/buy',  	   to: 'items#buy',  			         as: 'buy_items'
  get  '/sell', 	   to: 'items#sell', 			         as: 'sell_items'
  get  '/deposit',     to: 'deposits#show',                  as: 'deposit'
  get  '/checkout',    to: 'order_events#checkout',          as: 'checkout'
  get  '/deposits',    to: 'deposits#index',                 as: 'deposits'
  get  '/view_cart',   to: 'shopping_cart#view_cart',        as: 'view_cart'
  get  '/clear_cart',  to: 'shopping_cart#clear_cart',       as: 'clear_cart'

  get  '/blockchain_callback', to: 'application#blockchain_callback', as: 'blockchain_callback'

  post '/add_cards',        to: 'credit_cards#process_bin',       as: 'process_bin'
  post '/add_to_cart',      to: 'shopping_cart#add_to_cart',      as: 'add_to_cart'
  post '/remove_from_cart', to: 'shopping_cart#remove_from_cart', as: 'remove_from_cart'


  root 'activities#index'
end
