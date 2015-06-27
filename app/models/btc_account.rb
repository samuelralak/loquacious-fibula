class BtcAccount < ActiveRecord::Base
  belongs_to :user, inverse_of: :btc_account
  has_one :btc_account_balance, inverse_of: :btc_account
end
