class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.date :start_date
      t.date :end_date
      t.string :query
      t.string :cookie
      t.string :author_email
      t.string :author_name
      t.string :source_type
      t.integer :status

      t.timestamps
    end
  end
end
