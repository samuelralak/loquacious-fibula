class CreateSellerRequestStatuses < ActiveRecord::Migration
    def migrate(direction)
        super
        # Create seller_request_statuses
        SellerRequestStatus.create!(name: 'pending', code: 'PENDING', is_active: true) if direction == :up
        SellerRequestStatus.create!(name: 'confirmed', code: 'CONFIRMED', is_active: true) if direction == :up
        SellerRequestStatus.create!(name: 'rejected', code: 'REJECTED', is_active: true) if direction == :up
    end
    def change
        create_table :seller_request_statuses do |t|
            t.string :name
            t.string :code
            t.boolean :is_active

            t.timestamps null: false
        end
    end
end
