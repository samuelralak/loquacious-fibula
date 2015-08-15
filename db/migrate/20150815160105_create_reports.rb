class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.text :message
      t.boolean :is_reported, default: false
      t.references :item, index: true
      t.references :report_status, index: true

      t.timestamps null: false
    end
    add_foreign_key :reports, :items
    add_foreign_key :reports, :report_statuses
  end
end
