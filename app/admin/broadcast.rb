ActiveAdmin.register Broadcast do
    permit_params :title, :content, :admin_user_id

    form do |f|
        f.inputs "Broadcast" do
            f.input :admin_user_id, :as => :hidden, :input_html => { :value => current_admin_user.id }
            f.input :title
            f.input :content
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
