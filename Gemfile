source 'https://rubygems.org'

ruby "2.2.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

# database
gem 'pg'

# stylesheets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'bootstrap-sass', '~> 3.3.4.1'
gem 'font-awesome-rails', '~> 4.3.0.0'
gem 'world-flags', '~> 0.6.5'

# javascripts
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sweet-alert'
gem 'sweet-alert-confirm'
gem 'jquery-ui-rails'

# authentication
gem 'devise', '~> 3.5.1'

# docs generator
gem 'sdoc', '~> 0.4.0', group: :doc

# HTTP REST APIs
gem 'httparty', '~> 0.13.5'

# shopping cart
gem 'acts_as_shopping_cart', '~> 0.3.0'

# payment processing
gem 'block_io', '~> 1.0.6'
gem 'blockchain', github: 'blockchain/api-v1-client-ruby', branch: 'master'
gem 'aasm', '~> 4.1.1'

# env variables management
gem 'figaro', '~> 1.1.1'

# admin
gem 'activeadmin', github: 'activeadmin'

#production
gem 'rails_12factor', group: :production

# capistrano deployment
gem 'capistrano', '~> 3.1.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-rails-collection'

# Add this if you're using rbenv
# gem 'capistrano-rbenv', github: "capistrano/rbenv"

# Add this if you're using rvm
gem 'capistrano-rvm', github: "capistrano/rvm"

# background processing
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

# pagination
gem 'kaminari'

# web server and deployment
group :development do
	gem 'capistrano-ssh-doctor', '~> 1.0'
    gem 'capistrano3-puma',   require: false
end

gem 'puma'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end
