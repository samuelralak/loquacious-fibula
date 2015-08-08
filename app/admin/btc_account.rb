ActiveAdmin.register BtcAccount do
    actions :all, except: [:create, :update, :destroy, :edit]

    index do
        column :user
        column :label
        column :address
        actions
    end

    show do
        attributes_table do
            row :available_balance do
                btc_account.btc_account_balance.available_balance
            end
            row :pending_received_balance do
                btc_account.btc_account_balance.pending_received_balance
            end
        end
        active_admin_comments
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
