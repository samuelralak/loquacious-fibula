ActiveAdmin.register User do
   permit_params :can_sell
    index do
        column :id
        column :username
        column :email
        column :icq_number
        actions
    end

  form do |f|
    f.inputs "Confirm User", style: "max-width:820px" do
      f.input :username, input_html: {readonly: true, style: "background:#EFEFEF"}
      f.input :can_sell
    end
    f.actions
  end
end
