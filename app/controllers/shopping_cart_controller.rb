class ShoppingCartController < ApplicationController
	def add_to_cart
		@cart = Cart.create

		if params[:id] 
			@item = Item.find(params[:id])
		end
	end

  def remove_from_cart
  end
end
