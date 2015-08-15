class CreateReportStatuses < ActiveRecord::Migration
	def migrate(direction)
        super
        # Create withdrwawl_request_statuses
        ReportStatus.create!(name: 'reported', code: 'PENDING', is_active: true) if direction == :up
    end

  	def change
    	create_table :report_statuses do |t|
      		t.string :name
      		t.string :code
      		t.boolean :is_active

      		t.timestamps null: false
    	end
  	end
end
