class RemoveSellerIdFromOrder < ActiveRecord::Migration
  def change
    remove_index :orders, :seller_id
    remove_column :orders, :seller_id, :integer
  end
end
