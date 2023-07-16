class RemoveDetailsFromNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :date, :date
    remove_column :notifications, :time, :time
  end
end
