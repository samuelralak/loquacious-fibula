class ShoppingCart < ActiveRecord::Base
	acts_as_shopping_cart
	belongs_to :user, inverse_of: :shopping_cart
end
