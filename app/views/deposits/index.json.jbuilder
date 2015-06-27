json.array!(@deposits) do |deposit|
  json.extract! deposit, :id, :address, :available_balance, :pending_received, :user_id
  json.url deposit_url(deposit, format: :json)
end
