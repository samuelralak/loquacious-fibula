class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @item.itemable
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
      if params[:ids]
          params[:ids].map { |e|
              item = Item.find(e)
              itemable = item.itemable
              item.destroy
              itemable.destroy
          }
      else
          @itemable = @item.itemable
          @item.destroy
          @itemable.destroy
      end

      respond_to do |format|
          format.html { redirect_to sell_items_url, notice: 'Item was successfully destroyed.' }
          format.json { head :no_content }
      end
  end

  def destroy_multiple
      if params[:ids]
          ids = params[:ids].map(&:to_i)
          ids.map { |e|
              item = Item.find(e)
              itemable = item.itemable
              item.destroy
              itemable.destroy
          }
      end

      respond_to do |format|
          format.html { redirect_to sell_items_url, notice: 'Item was successfully destroyed.' }
          format.json { render json: {ids: ids  }}
      end
  end

  def sell
    if !current_user.can_sell && current_user.seller_request.nil?
      flash.now[:warning] = "You are not allowed to sell"

    elsif !current_user.can_sell && current_user.seller_request
      flash.now[:info] = "You have already sent a request to become a seller"

    else
      @items = current_user.items.all
    end
  end

  def buy
    # @items = Item.where(["aasm_state = :state", { :state => "active" }]).order("created_at desc").page(params[:page]) 
    @items = Item.where(["aasm_state != :state", { :state => "inactive" }]).order("created_at desc").page(params[:page]) 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = current_user.items.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(
        :itemable_id, :itemable_type, :price, :user_id, itemable_attributes: [:id,
          :card_holder, :card_number, :cvv, :expiry, :card_info])
    end
end
