class AddPasswordChangedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_changed_at, :timestamp
  end
end
