class Order < ActiveRecord::Base
    include AASM

    belongs_to :order_status
	belongs_to :customer, class_name: "User"

    has_one :order_item, dependent: :destroy

	validates :customer_id, presence: true

    after_update :check_status

    aasm :whiny_transitions => false do
        state :pending, :initial => true, :before_enter => :assign_order_status
        state :confirmed
        state :cancelled
        state :disputed
        state :refunded
        state :declined

        event :confirm do
            transitions :from => :pending, :to => :confirmed
        end

        event :cancel do
            transitions :from => [:pending, :disputed, :declined], :to => :cancelled
        end

        event :dispute do
            transitions :from => :pending, :to => :disputed
        end

        event :refund do
            after do
                refund_buyer(self.id)
            end

            transitions :from => [:pending, :disputed], :to => :refunded
        end

        event :decline do
            transitions :from => [:pending, :disputed], :to => :declined
        end
    end

    def assign_order_status
        self.order_status_id = OrderStatus.find_by(code: "PENDING").id
    end

    def refund_buyer(order_id)
        order = Order.find(order_id)
        seller = order.order_item.item.user
        credit_balance = seller.btc_account.btc_account_balance.available_balance.to_f - order.order_item.price.to_f  
        customer = order.customer
        debit_balance = customer.btc_account.btc_account_balance.available_balance.to_f + order.order_item.price.to_f
            
        begin
            # update buyer balance
            customer.btc_account.btc_account_balance.update(
                available_balance: debit_balance
            )
            # update seller balance
            seller.btc_account.btc_account_balance.update(
                available_balance: credit_balance
            )
        rescue StandardError => e
            puts "###### ERROR #{e}" 
            puts "###### BACKTRACE #{e.backtrace}"
        end
    end

    private
        def check_status
            if self.order_status_id.eql?(OrderStatus.find_by(code: "REFUNDED").id)
                self.refund!
            end

            if self.order_status_id.eql?(OrderStatus.find_by(code: "CONFIRMED").id)
                self.confirm!
            end
        end
end
