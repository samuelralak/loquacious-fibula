class CreateSellerRequests < ActiveRecord::Migration
  def change
    create_table :seller_requests do |t|
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :seller_requests, :users
  end
end
