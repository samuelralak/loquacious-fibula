class DepositsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_btc_account
    # before_action :check_transactions, only: [:show]
    before_action :check_balance

    def index
    end

    def show
        @transactions = current_user.transactions.order('time')
    end

    def send_coins
      @address = params[:address]
      @coins = params[:coins]

      begin
        @response = @wallet.send(@address, (@coins.to_f*100000000).to_i,
            from_address: current_user.btc_account.address
        )
        check_balance
      rescue Blockchain::APIException => e
        @error = true
        @exception = e
      end
    end

    private
        def set_btc_account
            @btc_account = current_user.btc_account
        end

        def check_balance
            account_balance = @btc_account.btc_account_balance
            balance = @wallet.get_address(@btc_account.address, confirmations = 1).balance

            if account_balance && !balance.nil?
                account_balance.update(
                    available_balance: balance
                )
            else
                @btc_account.create_btc_account_balance(
                    available_balance: balance
                )
            end
        end

        def check_transactions
            sent = BlockIo.get_transactions :type => 'sent', :labels =>  @btc_account.label

            if sent['status'].eql?('success')
                data = sent['data']

                if !data['txs'].length.eql?(0)
                    data['txs'].each do |txn|
                        current_user.transactions.where(txn_id: txn['txid']).first_or_create(
                            txn_id: txn['txid'],
                            time: Time.at(txn['time']),
                            amount: txn['amounts_sent'][0]['amount'],
                            sender: txn['senders'][0],
                            receiver: txn['amounts_sent'][0]['recipient'],
                            txn_type: "sent",
                            status: ""
                        )
                    end
                end
            end

            received = BlockIo.get_transactions :type => 'received', :labels =>  @btc_account.label

            if received['status'].eql?('success')
                data = received['data']

                if !data['txs'].length.eql?(0)
                    data['txs'].each do |txn|
                        current_user.transactions.where(txn_id: txn['txid']).first_or_create(
                            txn_id: txn['txid'],
                            time: Time.at(txn['time']),
                            amount: txn['amounts_received'][0]['amount'],
                            sender: txn['senders'][0],
                            receiver: txn['amounts_received'][0]['recipient'],
                            txn_type: "received",
                            status: ""
                        )
                    end
                end
            end
        end
end
