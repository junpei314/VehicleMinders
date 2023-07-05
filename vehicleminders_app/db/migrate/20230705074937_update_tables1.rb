class UpdateTables1 < ActiveRecord::Migration[7.0]
  def change
    remove_reference :vehicles, :user, index: true, foreign_key: true
  end
end
