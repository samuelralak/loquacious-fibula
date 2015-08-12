class Order < ActiveRecord::Base
    include AASM

    belongs_to :order_status
	belongs_to :customer, class_name: "User"

    has_one :order_item, dependent: :destroy

	validates :customer_id, presence: true

    after_update :check_status

    aasm :whiny_transitions => false do
        state :pending, :initial => true, :before_enter => :assign_order_status
        state :completed
        state :cancelled
        state :disputed
        state :refunded
        state :declined

        event :complete do
            transitions :from => :pending, :to => :completed
        end

        event :cancel do
            transitions :from => [:pending, :disputed, :declined], :to => :cancelled
        end

        event :dispute do
            transitions :from => :pending, :to => :disputed
        end

        event :refund do
            transitions :from => :disputed, :to => :refunded
        end

        event :decline do
            after do
                refund_buyer(self.id)
            end

            transitions :from => [:pending, :disputed], :to => :declined
        end
    end

    def assign_order_status
        self.order_status_id = OrderStatus.find_by(code: "PENDING").id
    end

    def refund_buyer(order_id)
        order = Order.find(order_id)

        begin
            wallet = Blockchain::Wallet.new(ENV['BLOCKCHAIN_IDENTIFIER'], ENV['BLOCKCHAIN_PASSWORD'])
            wallet.send(
                order.customer.btc_account.address,
                (order.order_total.to_f*100000000).to_i,
                from_address: order.order_item.item.user.btc_account.address
            )
        rescue Blockchain::APIException => e
            puts "###### ERROR #{e}" 
            puts "###### BACKTRACE #{e.backtrace}"
        end
    end

    private
        def check_status
            if self.order_status_id.eql?(OrderStatus.find_by(code: "DECLINED").id)
                self.decline!
            end

            if self.order_status_id.eql?(OrderStatus.find_by(code: "COMPLETED").id)
                self.complete!
            end
        end
end
