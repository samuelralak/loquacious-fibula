class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order_total
      t.integer :seller_id
      t.integer :customer_id
      t.references :order_status, index: true

      t.timestamps null: false
    end
    add_index :orders, :seller_id
    add_index :orders, :customer_id
    add_foreign_key :orders, :order_statuses
  end
end
