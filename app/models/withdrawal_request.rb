class WithdrawalRequest < ActiveRecord::Base
  belongs_to :user, inverse_of: :withdrawal_requests
  belongs_to :withdrawal_request_status, inverse_of: :withdrawal_requests
end
