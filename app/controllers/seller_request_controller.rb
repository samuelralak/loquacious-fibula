class SellerRequestController < ApplicationController
    before_action :authenticate_user!
  def create
    @request = current_user.build_seller_request
    @request.seller_request_status_id = SellerRequestStatus.find_by(code: 'PENDING').id

    respond_to do |format|
      if @request.save
        @request.user.can_sell = false
        @request.user.save!
        format.html { redirect_to sell_items_url, notice: 'Request sent successfully pending confirmation by admin' }
        format.js
      else
        format.html { redirect_to sell_items_url }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  private
      # Never trust parameters from the scary internet, only allow the white list through.
      def seller_request_params
          params.require(:seller_request).permit(:user_id, :status)
      end
end
