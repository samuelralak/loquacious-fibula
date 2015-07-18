class AddStatusToSellerRequest < ActiveRecord::Migration
  def change
    add_column :seller_requests, :status, :string
  end
end
