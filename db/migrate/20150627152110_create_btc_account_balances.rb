class CreateBtcAccountBalances < ActiveRecord::Migration
  def change
    create_table :btc_account_balances do |t|
      t.float :available_balance
      t.float :pending_received_balance
      t.references :btc_account, index: true

      t.timestamps null: false
    end
    add_foreign_key :btc_account_balances, :btc_accounts
  end
end
