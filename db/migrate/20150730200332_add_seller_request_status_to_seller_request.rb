class AddSellerRequestStatusToSellerRequest < ActiveRecord::Migration
  def change
    add_reference :seller_requests, :seller_request_status, index: true
    add_foreign_key :seller_requests, :seller_request_statuses
  end
end
