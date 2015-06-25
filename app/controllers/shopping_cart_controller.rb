class ShoppingCartController < ApplicationController
	def add_to_cart
		@cart = ShoppingCart.create
		@item = Item.find(params[:id])

		if @item
			@cart.add(@item, @item.price)
			@success = "Item successfully added to cart"
		else
			@error = "you have not selected any item"
		end

		respond_to do |format|
			format.html { redirect_to buy_items_path }
			format.js
		end
	end

  	def remove_from_cart
  	end
end
