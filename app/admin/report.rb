ActiveAdmin.register Report do
	index do
		selectable_column
    	column :item do |report|
        	"#{report.item.itemable.card_number}|#{report.item.itemable.expiry}|#{report.item.itemable.cvv}"
      	end
      	column "Reporter" do |report|
      		report.user.username
      	end

      	column "Reporter message" do |report|
      		report.message
      	end

      	column "Seller" do |report|
      		report.item.user.username
      	end

      	column :created_at
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
