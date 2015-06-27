class BtcAccountBalance < ActiveRecord::Base
  belongs_to :btc_account, inverse_of: :btc_account
end
