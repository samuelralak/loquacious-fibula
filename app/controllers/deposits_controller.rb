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
      address = params[:address]
      coins = params[:coins]

      begin
        request = WithdrawalRequest.find_by(user_id: current_user.id)

        if coins.to_f <= current_user.btc_account.btc_account_balance.available_balance.to_f
            if request && !request.is_done
                raise 'You still have a pending Withdrawal Request'
            else
                WithdrawalRequest.create!(
                    send_to_address: address,
                    amount: coins,
                    user_id: current_user.id,
                    withdrawal_request_status_id: WithdrawalRequestStatus.find_by(code: 'PENDING').id
                )
                @error = false
            end
        else
            raise 'Insufficient funds'
        end
      rescue StandardError => e
        @error = true
        @exception = e
      end
    end

    private
        def set_btc_account
            @btc_account = current_user.btc_account
        end

        def check_balance
            active_addresses = Array.new
            account_balance = @btc_account.btc_account_balance
            current_server_balance = @wallet.get_address(@btc_account.address, confirmations = 1)

            @wallet.list_addresses.each do |addr|
                active_addresses = active_addresses << addr.address
            end

            logger.info "######### ACTIVE ADDRESSES: #{active_addresses.inspect}"
            if active_addresses.include?(current_server_balance.address)
                if account_balance
                    initial_server_balance = @btc_account.btc_account_balance.server_balance
                    
                    if initial_server_balance.nil?
                        account_balance.update(
                            available_balance: (current_server_balance.balance.to_f/100000000)*1,
                            server_balance: (current_server_balance.balance.to_f/100000000)*1
                        )
                    else
                        if ((current_server_balance.balance.to_f/100000000)*1) > initial_server_balance.to_f
                            current_server_balance = (current_server_balance.balance.to_f/100000000)*1
                            difference = current_server_balance - initial_server_balance.to_f
                            new_balance = account_balance.available_balance.to_f + difference

                            account_balance.update(
                                available_balance: new_balance,
                                server_balance: current_server_balance
                            ) 
                        else
                            account_balance.update(
                                server_balance: (current_server_balance.balance.to_f/100000000)*1
                            )
                        end
                    end
                else
                    @btc_account.create_btc_account_balance(
                        available_balance: (current_server_balance.balance.to_f/100000000)*1,
                        server_balance: (current_server_balance.balance.to_f/100000000)*1
                    )
                end
            else
                label = SecureRandom.uuid
                new_address = @wallet.new_address(label)

                account = @btc_account.update(
                    label: new_address.label, address: new_address.address
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
