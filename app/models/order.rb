class Order < ActiveRecord::Base
    include AASM

    belongs_to :order_status
	belongs_to :customer, class_name: "User"

    has_many :order_items

	validates :customer_id, presence: true

    aasm :whiny_transitions => false do
        state :pending, :initial => true
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
            transitions :from => [:pending, :disputed], :to => :declined
        end
    end
end
