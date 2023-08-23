class AddJidToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :jid_email, :string
    add_column :notifications, :jid_teams, :string
  end
end
