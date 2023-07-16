class AddTimeToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :time, :time
  end
end
