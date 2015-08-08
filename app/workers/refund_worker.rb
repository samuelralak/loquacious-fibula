class RefundWorker
    include Sidekiq::Worker

    def perform(order_id)
        order = Order.find(order_id)

        begin
            wallet = Blockchain::Wallet.new(ENV['BLOCKCHAIN_IDENTIFIER'], ENV['BLOCKCHAIN_PASSWORD'])
            wallet.send(
                order.customer.btc_account.address,
                (order.order_total.to_f*100000000).to_i,
                from_address: order.order_items.first.item.user.btc_account.address
            )
        rescue Blockchain::APIException => e
            logger.info "###### ERROR #{e}"
            logger.info "###### BACKTRACE #{e.backtrace}"
        end
    end
end
