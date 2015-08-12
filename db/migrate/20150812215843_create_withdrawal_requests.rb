class CreateWithdrawalRequests < ActiveRecord::Migration
  def change
    create_table :withdrawal_requests do |t|
      t.string :send_to_address
      t.string :amount
      t.boolean :is_done, default: false
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :withdrawal_requests, :users
  end
end
