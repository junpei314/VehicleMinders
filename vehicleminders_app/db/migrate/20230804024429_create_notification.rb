class CreateNotification < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :vehicle, foreign_key: true
      t.datetime :datetime
      
      t.timestamps
    end
  end
end
