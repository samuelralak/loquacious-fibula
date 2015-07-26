class OrdersController < ApplicationController
    def index
        @orders = Order.where(customer_id: current_user.id).order('created_at desc')
    end

    def show
        @order = current_user.orders.find(params[:id])
    end

    def check
        @response = HTTParty.get("http://www.ug-market.com/ugm/xcheck.php?user=g0rx9&pwd=rootxroot&gate=checkcvv9&cc=4561429448602999|02/2016|678")

        respond_to do |format|
            format.js
        end
    end
end
