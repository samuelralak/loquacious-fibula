class AddLastActivityAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_activity_at, :timestamp
  end
end
