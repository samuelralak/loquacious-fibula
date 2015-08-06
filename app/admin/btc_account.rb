ActiveAdmin.register BtcAccount do
    index do
        column :user
        column :label
        column :address
        column :btc_account_balance['available_balance']
        column :btc_account_balance
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
