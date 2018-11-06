class AddAuthstringRequests1 < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :authstring, :string
  end
end
