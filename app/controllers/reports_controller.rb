class ReportsController < ApplicationController
	before_action :authenticate_user!

	def create
		@report = current_user.reports.new(report_params)

    	respond_to do |format|
      		if @report.save
      			item = Item.find(@report.item_id)
      			item.is_reported = true
      			item.save 

        		format.html { redirect_to orders_path, notice: 'You have successfully reported item' }
        		format.json { render :show, status: :created, location: @report }
      		else
        		format.html { render :new }
        		format.json { render json: @report.errors, status: :unprocessable_entity }
      		end
    	end
	end

	private 
		# Never trust parameters from the scary internet, only allow the white list through.
    	def report_params
      		params.require(:report).permit(
        		:user_id, :item_id, :message
        	)
    	end
end
