class CreateWithdrawalRequestStatuses < ActiveRecord::Migration
	def migrate(direction)
        super
        # Create withdrwawl_request_statuses
        WithdrawalRequestStatus.create!(name: 'pending', code: 'PENDING', is_active: true) if direction == :up
        WithdrawalRequestStatus.create!(name: 'confirmed', code: 'CONFIRMED', is_active: true) if direction == :up
        WithdrawalRequestStatus.create!(name: 'declined', code: 'DECLINED', is_active: true) if direction == :up
    end

  	def change
    	create_table :withdrawal_request_statuses do |t|
      		t.string :name
      		t.string :code
      		t.boolean :is_active

      		t.timestamps null: false
    	end
  	end
end
