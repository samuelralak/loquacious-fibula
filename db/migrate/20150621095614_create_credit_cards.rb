class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.integer :bin
      t.string :card_number
      t.string :card_holder
      t.integer :cvv
      t.date :expiry
      t.string :brand
      t.string :card_type
      t.string :bank
      t.string :country_code
      t.string :country_name
      t.string :state
      t.string :city
      t.string :zip

      t.timestamps null: false
    end
  end
end
