class SellerRequestStatus < ActiveRecord::Base
    has_many :seller_requests, inverse_of: :seller_request_status
end
