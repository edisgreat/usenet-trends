class AddDebugCols < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :debug_payload, :text
    add_column :results, :debug_result, :text
  end
end
