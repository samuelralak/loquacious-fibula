class OrderEventsController < ApplicationController

    def checkout
        # Find the shopping cart
        shopping_cart = ShoppingCart.find(params[:cart_id])

        # get balances from BlockIo API
        api_balance = @wallet.get_address(current_user.btc_account.address, confirmations = 1).balance
        btc_account_balance = current_user.btc_account.btc_account_balance

        begin
            # create order with initial status of pending
            order = Order.create(
                order_total: params[:total], customer_id: shopping_cart.user.id
            )

            # get shopping cart items
            shopping_cart_items = shopping_cart.shopping_cart_items.all

            shopping_cart_items.map { |sci|
                # transfer coins from buyer's address to seller's address
                @wallet.send(
                    sci.item.user.btc_account.address,
                    (sci.item.price.to_f*100000000).to_i,
                    from_address: shopping_cart.user.btc_account.address
                )

                # update seller's balance -  debit item price to available_balance
                seller_balance = @wallet.get_address(sci.item.user.btc_account.address, confirmations = 1).balance
                sci.item.user.btc_account.btc_account_balance.update(
                    available_balance: seller_balance
                )

                # create order items
                order.order_items.create(
                    item_id: sci.item.id, price: sci.item.price, quantity: sci.quantity
                )
            }

            # update buyer's balance - credit the total amount from buyer's available_balance
            buyer_balance = @wallet.get_address(shopping_cart.user.btc_account.address, confirmations = 1).balance
            shopping_cart.user.btc_account.btc_account_balance.update(
                available_balance: buyer_balance
            )

            # clear and delete cart
            shopping_cart.clear
            shopping_cart.destroy

            # redirect to orders page
            respond_to do |format|
                flash[:warning] = "You have 15 minutes to check the validity of your cards"
                format.html { redirect_to order_order_items_path(order) }
                format.js
            end
        rescue Blockchain::APIException => e
            flash.now[:error] = e
            redirect_to view_cart_path
        end
    end

    def refund

    end

    def dispute

    end

    def cancel

    end
end
