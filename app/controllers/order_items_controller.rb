class OrderItemsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        order = Order.find(params[:order_id])
        @order_items = order.order_items.all
    end
end
