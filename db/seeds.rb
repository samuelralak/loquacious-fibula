order_statuses = ['pending', 'completed', 'cancelled', 'refunded', 'declined']

order_statuses.map { |order_status|
    OrderStatus.where(code: order_status.upcase.gsub(' ', '-')).first_or_create!(
        name: order_status,
        code: order_status.upcase.gsub(' ', '-'),
        is_active: true
    )
}

order_types = ['purchase', 'sale']

order_types.map { |order_type|
    OrderType.where(code: order_type.upcase.gsub(' ', '-')).first_or_create!(
        name: order_type,
        code: order_type.upcase.gsub(' ', '-'),
        is_active: true
    )
}

AdminUser.create(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
)
