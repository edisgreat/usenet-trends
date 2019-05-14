class AddAdminStrings < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_strings do |t|
      t.text :cookie
      t.text :authstring
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
