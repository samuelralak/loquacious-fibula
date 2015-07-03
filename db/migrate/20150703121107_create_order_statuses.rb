class CreateOrderStatuses < ActiveRecord::Migration
  def change
    create_table :order_statuses do |t|
      t.string :name
      t.string :code
      t.boolean :is_active

      t.timestamps null: false
    end
  end
end
