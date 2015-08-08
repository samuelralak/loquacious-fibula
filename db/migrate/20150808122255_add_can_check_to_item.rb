class AddCanCheckToItem < ActiveRecord::Migration
  def change
    add_column :items, :can_check, :boolean, default: true
  end
end
