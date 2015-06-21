json.array!(@items) do |item|
  json.extract! item, :id, :itemable_id, :itemable_type, :price, :user_id
  json.url item_url(item, format: :json)
end
