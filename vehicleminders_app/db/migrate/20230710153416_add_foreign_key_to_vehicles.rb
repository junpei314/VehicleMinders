class AddForeignKeyToVehicles < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :vehicles, :users
  end
end
