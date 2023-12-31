class CreateUser < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :webhook_url
      t.string :password_digest
      t.string :remember_digest
      t.boolean :email_notification, default: false
      t.boolean :webhook_notification, default: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
