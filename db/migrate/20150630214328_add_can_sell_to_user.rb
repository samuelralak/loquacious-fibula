class AddCanSellToUser < ActiveRecord::Migration
  def change
    add_column :users, :can_sell, :boolean, default: false
  end
end
