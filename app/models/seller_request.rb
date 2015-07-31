class SellerRequest < ActiveRecord::Base
  belongs_to :user, inverse_of: :seller_request
  belongs_to :seller_request_status, inverse_of: :seller_requests

  after_save :check_seller_status

  private
    def check_seller_status
        if self.seller_request_status && self.seller_request_status.code.eql?('PENDING')
            self.status = "PENDING"
            self.save!
            self.user.can_sell = false
            self.user.save!
        elsif self.seller_request_status && self.seller_request_status.code.eql?('CONFIRMED')
            self.status = "CONFIRMED"
            self.save!
            self.user.can_sell = true
            self.user.save!
        elsif self.seller_request_status && self.seller_request_status.code.eql?('REJECTED')
            self.status = "REJECTED"
            self.save!
            self.user.can_sell = false
            self.user.save!
        else
            self.status = "PENDING"
            self.save!
            self.user.can_sell = false
            self.user.save!
        end
    end
end
