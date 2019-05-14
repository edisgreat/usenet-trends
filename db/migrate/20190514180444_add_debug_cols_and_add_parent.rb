class AddDebugColsAndAddParent < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :debug_payload, :text
    add_column :results, :debug_result, :text
    add_column :results, :result_month_id, :integer
  end
end
