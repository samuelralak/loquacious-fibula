class ShoppingCartController < ApplicationController
	def add_to_cart
		@cart = Cart.create
		@item = Item.find(params[:id])
	end

  def remove_from_cart
  end
end
