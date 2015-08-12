class AddServerBalanceToBtcAccountBalance < ActiveRecord::Migration
  def change
    add_column :btc_account_balances, :server_balance, :string
  end
end
