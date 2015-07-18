class AddCardInfoToCreditCard < ActiveRecord::Migration
  def change
    add_column :credit_cards, :card_info, :text
  end
end
