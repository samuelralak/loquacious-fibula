class BtcAccount < ActiveRecord::Base
  belongs_to :user, inverse_of: :btc_account
  has_one :btc_account_balance, inverse_of: :btc_account
  
  accepts_nested_attributes_for :btc_account_balance
end
