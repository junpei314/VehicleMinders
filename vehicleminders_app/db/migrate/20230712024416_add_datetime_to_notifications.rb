class AddDatetimeToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :datetime, :datetime
  end
end
