class AddStatusReasonToWithdrawalRequest < ActiveRecord::Migration
  def change
    add_column :withdrawal_requests, :status_reason, :text
  end
end
