json.array!(@credit_cards) do |credit_card|
  json.extract! credit_card, :id, :bin, :card_number, :card_holder, :cvv, :expiry, :brand, :card_type, :bank, :country_code, :country_name, :state, :city, :zip
  json.url credit_card_url(credit_card, format: :json)
end
