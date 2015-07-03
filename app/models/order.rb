class Order < ActiveRecord::Base
    belongs_to :order_status
    belongs_to :seller, class_name: "User"
	belongs_to :customer, class_name: "User"

	validates :seller_id, presence: true
	validates :customer_id, presence: true
end
