class AddUserToShoppingCart < ActiveRecord::Migration
  def change
    add_reference :shopping_carts, :user, index: true
    add_foreign_key :shopping_carts, :users
  end
end
