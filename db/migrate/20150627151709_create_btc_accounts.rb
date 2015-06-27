class CreateBtcAccounts < ActiveRecord::Migration
  def change
    create_table :btc_accounts do |t|
      t.string :label
      t.string :address
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :btc_accounts, :users
  end
end
