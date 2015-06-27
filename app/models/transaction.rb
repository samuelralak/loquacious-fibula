class Transaction < ActiveRecord::Base
    belongs_to :user, inverse_of: :transactions
end
