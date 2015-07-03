order_statuses = ['pending', 'completed', 'cancelled', 'refunded', 'declined']

order_statuses.map { |order_status|
    OrderStatus.create!(
        name: order_status,
        code: order_status.upcase.gsub(' ', '-'),
        is_active: true
    )
}
