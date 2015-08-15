class AddIsReportedToItem < ActiveRecord::Migration
  def change
    add_column :items, :is_reported, :boolean, default: false
  end
end
