class SellerRequest < ActiveRecord::Base
  belongs_to :user, inverse_of: :seller_request
end
