class AddShoppingCartToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :shopping_cart, index: true
    add_foreign_key :orders, :shopping_carts
  end
end
