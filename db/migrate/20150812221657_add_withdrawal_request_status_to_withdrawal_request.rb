class AddWithdrawalRequestStatusToWithdrawalRequest < ActiveRecord::Migration
  def change
    add_reference :withdrawal_requests, :withdrawal_request_status, index: true
    add_foreign_key :withdrawal_requests, :withdrawal_request_statuses
  end
end
