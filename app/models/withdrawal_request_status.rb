class WithdrawalRequestStatus < ActiveRecord::Base
	has_many :withdrawal_requests, inverse_of: :withdrawal_request_status
end
