ActiveAdmin.register Order do
	permit_params :order_status_id

	index do
        selectable_column
        column :item do |order|
            "#{order.order_item.item.itemable.card_number}|#{order.order_item.item.itemable.expiry}|#{order.order_item.item.itemable.cvv}"
        end
        column :order_total
        column :customer
        column :seller do |order|
            order.order_item.item.user.username
        end
        column :order_status
        column :reported do |order|
            order.order_item.item.is_reported.eql?(true) ? link_to('YES', root_x_admi_n_report_path(order.order_item.item.report.id)) : "NO"
        end
        actions
    end

    show do
        attributes_table do
        	row :order_total
        	row :customer
            row :seller do
                order.order_item.item.user
            end
            row :item do
            	"#{order.order_item.item.itemable.card_number}|#{order.order_item.item.itemable.expiry}|#{order.order_item.item.itemable.cvv}"
            end
            row :order_status
        end
        active_admin_comments
    end

    form do |f|
        f.inputs "Order" do
            # f.input :admin_user_id, :as => :hidden, :input_html => { :value => current_admin_user.id }
            f.input :order_status
        end

        f.actions
    end
end
