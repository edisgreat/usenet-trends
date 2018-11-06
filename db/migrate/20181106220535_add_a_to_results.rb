class AddAToResults < ActiveRecord::Migration[5.2]
  def change
    add_reference :results, :request, foreign_key: true, index: true
  end
end
