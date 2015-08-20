class SellerRequest < ActiveRecord::Base
  belongs_to :user, inverse_of: :seller_request
  belongs_to :seller_request_status, inverse_of: :seller_requests

  before_save :check_seller_status

  private
    def check_seller_status
        if self.seller_request_status && self.seller_request_status.code.eql?('PENDING')
            self.status = "PENDING"
            user = User.find(self.user_id)
            user.update(can_sell: false)
        elsif self.seller_request_status && self.seller_request_status.code.eql?('CONFIRMED')
            self.status = "CONFIRMED"
            user = User.find(self.user_id)
            user.update(can_sell: true)
        elsif self.seller_request_status && self.seller_request_status.code.eql?('REJECTED')
            self.status = "REJECTED"
            user = User.find(self.user_id)
            user.update(can_sell: false)
        else
            self.status = "PENDING"
            user = User.find(self.user_id)
            user.update(can_sell: false)
        end
    end
end
