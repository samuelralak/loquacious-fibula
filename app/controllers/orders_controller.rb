class OrdersController < ApplicationController
    def index
        @orders = Orders.where(customer_id: current_user.id)
    end

    def show
        @order = current_user.orders.find(params[:id])
    end
end
