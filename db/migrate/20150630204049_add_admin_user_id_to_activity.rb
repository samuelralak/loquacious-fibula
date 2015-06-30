class AddAdminUserIdToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :admin_user, index: true
    add_foreign_key :activities, :admin_users
  end
end
