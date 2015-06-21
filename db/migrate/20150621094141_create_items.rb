class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.belongs_to :itemable, polymorphic: true, index: true
      t.float :price
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :items, :users
  end
end
