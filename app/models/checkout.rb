class Checkout
	def initialize(options)
		@cart = ShoppingCart.find(options[:cart_id])
		@total = options[:total]
	end

	def credit_buyer
		puts "####### CREDITTING BUYER"
		# get account
		account = BtcAccountBalance.find_by(btc_account_id: @cart.user.btc_account.id)
		# get current balance as old_balance
		current_balance = account.available_balance
		# check if user has insufficient funds
		if current_balance.to_f <= @total.to_f
			raise "insufficient funds"
		else
			# subtract total from old balance to get new balance
			new_balance = current_balance.to_f - @total.to_f
			new_balance = (new_balance).round(5)
			# update balance
			account.update!(available_balance: new_balance)
		end
	end

	def debit_seller
		puts "####### DEBITTING BUYER"
		# get all shopping cart items
		cart_items = @cart.shopping_cart_items.all
		# loop through each item
		cart_items.map { |cart_item|
			# get seller from cart item  
			seller = cart_item.item.user
			# get seller's account
			account = BtcAccountBalance.find_by(btc_account_id: seller.btc_account.id)
			# get sellers current balance
			current_balance = account.available_balance
			# add item price to current_balance to get new balance
			new_balance = current_balance.to_f + cart_item.item.price.to_f
			new_balance = (new_balance).round(5)
			# update balance
			account.update!(available_balance: new_balance) 
		}
	end

	def create_order
		puts "####### CREATING ORDER"
		# get all shopping cart items
		cart_items = @cart.shopping_cart_items.all
		# create order
		order = Order.create(
            order_total: @total, 
            customer_id: @cart.user.id
        )
        # create order items
        cart_items.map { |cart_item|  
        	order.create_order_item(
                item_id: cart_item.item.id, price: cart_item.item.price, quantity: cart_item.quantity
            )

        	puts "####### DEACTIVATING ITEM"
            cart_item.item.deactivate!
        }	
	end

	def destroy_cart
		puts "####### DESTROYING CART"
		# clear cart 
        @cart.clear
        # delete cart
        @cart.destroy
	end
end