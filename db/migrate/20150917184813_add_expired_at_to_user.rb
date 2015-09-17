class AddExpiredAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :expired_at, :timestamp
  end
end
