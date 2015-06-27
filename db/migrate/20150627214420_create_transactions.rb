class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :txn_id
      t.string :amount
      t.datetime :time
      t.string :sender
      t.string :receiver
      t.string :txn_type
      t.string :status

      t.timestamps null: false
    end
  end
end
