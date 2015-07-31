ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
     columns do
       column do
         panel "Recent Items" do
           ul do
             Item.order('created_at desc').map do |item|
               if item.itemable
                 li link_to(item.itemable.card_number,  root_x_admi_n_item_path(item))
               end
             end
           end
         end
       end

       column do
           panel "Seller Requests" do
             ul do
               SellerRequest.where(seller_request_status_id: "#{SellerRequestStatus.find_by(code: 'PENDING').id}").order('created_at desc').map do |seller_request|
                 li "#{seller_request.user.try(:username)} | #{seller_request.user.try(:email)} | #{seller_request.user ? link_to('confirm',  edit_root_x_admi_n_seller_request_path(seller_request)) : seller_request.id}".html_safe
               end
             end
           end
       end
     end
  end # content
end
