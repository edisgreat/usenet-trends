class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.date :start_date
      t.date :end_date
      t.integer :amount
      t.string :precision
      t.integer :status

      t.timestamps
    end
  end
end
