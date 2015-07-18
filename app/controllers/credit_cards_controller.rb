class CreditCardsController < ApplicationController
    before_action :set_credit_card, only: [:show, :edit, :update, :destroy]

    # GET /credit_cards
    # GET /credit_cards.json
    def index
        @credit_cards = CreditCard.all
    end

    # GET /credit_cards/1
    # GET /credit_cards/1.json
    def show
    end

    # GET /credit_cards/new
    def new
        @credit_card = CreditCard.new
    end

    # GET /credit_cards/1/edit
    def edit
    end

    # POST /credit_cards
    # POST /credit_cards.json
    def create
        @credit_cards = params[:credit_cards]

        @credit_cards.each do |cc|
            # expiry_date = cc["'expiry'"].map{|k,v| v}.join("-").to_date

            card = CreditCard.create!(
                bin: cc["'bin'"], card_number: cc["'card_number'"], card_info: cc["'card_info'"], cvv: cc["'cvv'"], expiry: cc["'expiry'"],
                brand: cc["'brand'"], card_type: cc["'card_type'"], bank: cc["'bank'"], country_code: cc["'country_code'"],
                country_name: cc["'country_name'"], card_category: cc["'card_category'"]
            )

            item = card.items.create!(price: cc["'price'"], user_id: current_user.id)
            track_activity(card)
        end

        redirect_to sell_items_path, notice: 'Credit cards were successfully created.'
    end

    # PATCH/PUT /credit_cards/1
    # PATCH/PUT /credit_cards/1.json
    def update
        respond_to do |format|
            if @credit_card.update(credit_card_params)
                format.html { redirect_to @credit_card, notice: 'Credit card was successfully updated.' }
                format.json { render :show, status: :ok, location: @credit_card }
            else
                format.html { render :edit }
                format.json { render json: @credit_card.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /credit_cards/1
    # DELETE /credit_cards/1.json
    def destroy
        @credit_card.destroy
        respond_to do |format|
            format.html { redirect_to credit_cards_url, notice: 'Credit card was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def process_bin
        @credit_cards = []
        # step 1: read file content
        # step 2: read each line
        # step 3: convert each line into an array
        # step 4: loop the array
        # step 5: insert each element with into a hash value with appropriate key
        # step 6: insert everything into an array


        if params[:file] && params[:file].respond_to?(:read)
            # read file content
            contents = params[:file].read
            # read each line of content
            contents.each_line do |line|
                card = Hash.new
                logger.info "########## READING EACH LINE: #{line.chomp.inspect}"
                # convert to array
                line = line.chomp.split("|")

                # create a hash with credit card details
                card = card.merge!(
                    card_number: line[0], expiry: line[1], cvv: line[2].to_i
                )

                # do a bin check
                response = HTTParty.get("http://www.binlist.net/json/#{card[:card_number][0..5]}")

                if response.code.eql?(200)
                    response_body = JSON.parse(response.body, symbolize_names: true)
                    logger.info "########## RESPONSE FROM BIN CHECK: #{response_body}"
                    # merge response to credit card hash
                    card = card.merge!(response_body)
                end

                # merge the hash into the credit card array
                @credit_cards << card
            end

            logger.info @credit_cards.inspect
        elsif params[:file] && params[:file].respond_to?(:path)
            logger.info "########## READING FILE PATH: "
            contents = File.read(params[:file].path)
            logger.info "########## FILE PATH CONTENTS: #{contents.inspect}"
        elsif params[:bin]
            params[:bin].each do |p|
                card = Hash.new
                p = p.split("|")

                # create a hash with credit card details
                card = card.merge!(
                    card_number: p[0], expiry: p[1], cvv: p[2].to_i
                )

                # do a bin check
                response = HTTParty.get("http://www.binlist.net/json/#{card[:card_number][0..5]}")

                if response.code.eql?(200)
                    response_body = JSON.parse(response.body, symbolize_names: true)
                    logger.info "########## RESPONSE FROM BIN CHECK: #{response_body}"
                    # merge response to credit card hash
                    card = card.merge!(response_body)
                end

                # merge the hash into the credit card array
                @credit_cards << card
            end

            if @credit_cards.size.eql?(0)
                flash[:error] = "No results were found. please ensure that you entered a valid BIN number"
                redirect_to sell_items_url
            end
            logger.info @credit_cards.inspect
        else
            logger.info "########## NO PARAM: "
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_credit_card
            @credit_card = CreditCard.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def credit_card_params
            params.require(:credit_card).permit(:bin, :card_number, :card_holder, :cvv, :expiry, :brand, :card_type, :bank, :country_code, :country_name, :state, :city, :zip)
        end
end
