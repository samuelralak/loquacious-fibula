class DepositsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_btc_account, only: [:show]
    before_action :check_transactions, only: [:show]
    before_action :check_balance

    def index
    end

    def show
        @transactions = current_user.transactions.order('time')
    end

    private
        def set_btc_account
            @btc_account = current_user.btc_account
        end

        def check_balance
            account_balance = @btc_account.btc_account_balance
            response = BlockIo.get_address_balance :labels => @btc_account.label

            if account_balance && response['status'].eql?('success')
                data = response['data']
                account_balance.update(
                    available_balance: data['available_balance'],
                    pending_received_balance: data['pending_received_balance']
                )
            else
                data = response['data']
                @btc_account.create_btc_account_balance(
                    available_balance: data['available_balance'],
                    pending_received_balance: data['pending_received_balance']
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
