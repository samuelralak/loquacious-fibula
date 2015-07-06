class OrderItemsController < ApplicationController
    def index
        order = Order.find(params[:order_id])
        @order_items = order.order_items.all
    end
end
