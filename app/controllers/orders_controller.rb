class OrdersController < ApplicationController
    before_action :get_orders, only: [:index, :check_cards]

    def index

    end

    def show
        @order = current_user.orders.find(params[:id])
    end

    def check_cards

    end

    def check
        @order = Order.find(params[:order_item_id])
        item = @order.order_items.first.item
        cc = "#{item.itemable.card_number.to_i}|#{item.itemable.expiry.insert(2, '|')}|#{item.itemable.cvv}"
        @response = HTTParty.get("http://www.ug-market.com/ugm/xcheck.php?user=g0rx9&pwd=rootxroot&gate=checkcvv9&cc=#{cc}")
        # convert response to string
        @response = @response.to_s
        # partition string
        @response = @response.partition('_')
        # get status from partition response
        @status = @response[0].partition('=').last.downcase
        logger.info "######## STATUS: #{@status}"

        case @status
            when "live"
                logger.info "######## ITS LIVE"
                @order.complete!
                disable_check(@order)
            when "die"
                logger.info "######## ITS DEAD"
                @order.decline!
                disable_check(@order)
                RefundWorker.perform_async(@order.id)
            when "invalid"
                logger.info "######## ITS INVALID"
                @order.decline!
                disable_check(@order)
                RefundWorker.perform_async(@order.id)
            end

        respond_to do |format|
            format.js
        end
    end

    private
        def disable_check(order)
            order.order_items.first.item.can_check = false
            order.order_items.first.item.save!
        end

        def get_orders
            @orders = Order.where(customer_id: current_user.id).order('created_at desc')
        end
end
