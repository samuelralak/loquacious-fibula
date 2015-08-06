class AddAasmStateToItem < ActiveRecord::Migration
  def change
    add_column :items, :aasm_state, :string, null: false, default: "active"
  end
end
