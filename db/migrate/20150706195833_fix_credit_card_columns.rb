class FixCreditCardColumns < ActiveRecord::Migration
  def change
      change_column :credit_cards, :expiry, :string
  end
end
