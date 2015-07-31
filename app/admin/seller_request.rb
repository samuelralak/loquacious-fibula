ActiveAdmin.register SellerRequest do
    permit_params :status, :user_id, :seller_request_status_id
    index do
        column :user
        column :seller_request_status
        column :created_at
        actions
    end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
