require 'sidekiq/web'

Rails.application.routes.draw do
  captcha_route
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :items, except: [:index, :new]
  resources :reports
  resources :activities
  resources :credit_cards

  resources :orders do
      resources :order_items
  end

  devise_for :users

  get  '/buy',  	   to: 'items#buy',  			   as: 'buy_items'
  get  '/sell', 	   to: 'items#sell', 			   as: 'sell_items'
  get  '/sales',      to: 'orders#sales',         as: 'sales'
  get  '/check/:order_item_id', to: 'orders#check',    as: 'check'
  get  '/deposit',     to: 'deposits#show',            as: 'deposit'
  get  '/deposits',    to: 'deposits#index',           as: 'deposits'
  get  '/view_cart',   to: 'shopping_cart#view_cart',  as: 'view_cart'
  get  '/clear_cart',  to: 'shopping_cart#clear_cart', as: 'clear_cart'
  get  '/check_cards', to: 'orders#check_cards',       as: 'check_cards'

  get  '/blockchain_callback', to: 'application#blockchain_callback', as: 'blockchain_callback'

  post '/add_cards',        to: 'credit_cards#process_bin',       as: 'process_bin'
  post  '/checkout',    to: 'order_events#checkout',    as: 'checkout'
  post '/send_coins',       to: 'deposits#send_coins',            as: 'send_coins'
  post '/add_to_cart',      to: 'shopping_cart#add_to_cart',      as: 'add_to_cart'
  post '/become_seller',    to: 'seller_request#create',          as: 'become_seller'
  post '/remove_from_cart', to: 'shopping_cart#remove_from_cart', as: 'remove_from_cart'
  post '/delete_multiple_items', to: 'items#destroy_multiple', as: 'delete_multiple_items'

  root 'activities#index'
  mount Sidekiq::Web => '/sidekiq'
end
