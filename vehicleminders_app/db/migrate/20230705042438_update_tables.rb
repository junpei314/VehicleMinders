class UpdateTables < ActiveRecord::Migration[7.0]
  def change
    remove_reference :users, :vehicle, index: true, foreign_key: true
    add_reference :vehicles, :user, index: true, foreign_key: true
  end
end
