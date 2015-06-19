class AddIcqNumberAndUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :icq_number, :integer
    add_column :users, :username, :string
    add_index :users, :username, unique: true
  end
end
