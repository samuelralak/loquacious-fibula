class OrderEventsController < ApplicationController
    before_action :authenticate_user!
    def checkout
        checkout = Checkout.new(cart_id: params[:cart_id], total: params[:total])

        begin
            credit_buyer = checkout.credit_buyer
            debit_seller = checkout.debit_seller
            create_order = checkout.create_order
            destroy_cart = checkout.destroy_cart

            # redirect to orders page
            respond_to do |format|
                flash[:warning] = "Your order is pending confirmation from admin. You will be refunded if declined."
                format.html { redirect_to orders_path }
                format.js
            end
        rescue StandardError => e
            respond_to do |format|
                flash[:error] = e.to_s
                ErrorMailer.send_error(e).deliver_now
                format.html { redirect_to view_cart_path }
            end
        end
    end
end
