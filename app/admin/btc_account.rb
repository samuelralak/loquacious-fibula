ActiveAdmin.register BtcAccount do
    actions :all, except: [:create, :destroy]
    permit_params btc_account_balance_attributes: [:available_balance]

    index do
        selectable_column
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
            row :server_balance do
                btc_account.btc_account_balance.server_balance
            end
        end
        active_admin_comments
    end

    form do |f|
        f.inputs "Available balance" do
            f.semantic_fields_for :btc_account_balance do |f2|
                f2.input :available_balance
            end
        end

        f.actions
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
