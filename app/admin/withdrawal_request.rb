ActiveAdmin.register WithdrawalRequest do
	permit_params :is_done, :withdrawal_request_status, :status_reason

	index do
        column :user
        column :amount
        column :send_to_address
        column :is_done
        column :withdrawal_request_status
        column :status_reason
        column :created_at
        actions
    end

    form do |f|
        f.inputs "Withdrawal Request" do
            f.input :is_done
            f.input :withdrawal_request_status
            f.input :status_reason
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
