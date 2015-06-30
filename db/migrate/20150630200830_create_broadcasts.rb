class CreateBroadcasts < ActiveRecord::Migration
  def change
    create_table :broadcasts do |t|
      t.string :title
      t.text :content
      t.references :admin_user, index: true

      t.timestamps null: false
    end
    add_foreign_key :broadcasts, :admin_users
  end
end
