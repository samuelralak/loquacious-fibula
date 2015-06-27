class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.string :address
      t.float :available_balance
      t.float :pending_received
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :deposits, :users
  end
end
