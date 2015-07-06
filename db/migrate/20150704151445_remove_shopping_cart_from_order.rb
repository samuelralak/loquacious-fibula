class RemoveShoppingCartFromOrder < ActiveRecord::Migration
  def change
    remove_index :orders, :shopping_cart_id
    remove_column :orders, :shopping_cart_id, :integer
  end
end
