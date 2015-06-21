class CreditCard < ActiveRecord::Base
	has_many :items, as: :itemable
end
