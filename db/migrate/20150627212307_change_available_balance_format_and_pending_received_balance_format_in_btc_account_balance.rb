class ChangeAvailableBalanceFormatAndPendingReceivedBalanceFormatInBtcAccountBalance < ActiveRecord::Migration
  def change
      change_column :btc_account_balances, :available_balance, :string
      change_column :btc_account_balances, :pending_received_balance, :string
  end
end
