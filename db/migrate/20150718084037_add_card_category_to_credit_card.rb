class AddCardCategoryToCreditCard < ActiveRecord::Migration
  def change
    add_column :credit_cards, :card_category, :string
  end
end
