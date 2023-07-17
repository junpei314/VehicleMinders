class CreateVehicle < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :maker
      t.string :model
      t.integer :production_year
      t.string :license_plate
      t.date :lease_expiry
      t.date :inspection_due
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
