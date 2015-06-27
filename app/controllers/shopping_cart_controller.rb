class ShoppingCartController < ApplicationController
	before_action :authenticate_user!

	def view_cart
		@total = 0.00

		@cart.shopping_cart_items.each do |cart_item|
			@total = @total + cart_item.item.price
		end
	end

	def add_to_cart
		shopping_cart = ShoppingCart.find_by(user_id: current_user.id)

		if shopping_cart
			@cart = shopping_cart
		else
			@cart = current_user.create_shopping_cart!
		end

		@item = Item.find(params[:id])

		if @item
			@cart.add(@item, @item.price)
			@success = "Item successfully added to cart"
		else
			@error = "you have not selected any item"
		end

		respond_to do |format|
			# format.html { redirect_to buy_items_path }
			format.json { render json: { cart_item_count: @cart.shopping_cart_items.count } }
		end
	end

  	def remove_from_cart
  		@item = Item.find(params[:id])

  		if @item
  			@cart.remove(@item, @cart.shopping_cart_items.find_by(item: @item).quantity)
  		end

  		respond_to do |format|
				# format.html { redirect_to buy_items_path }
				format.json { render json: { cart_item_count: @cart.shopping_cart_items.count, item_price: @item.price} }
			end
  	end
end