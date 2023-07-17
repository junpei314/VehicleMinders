# frozen_string_literal: true

# ReminderMailerWorker
#
# このワーカーは、メール送信を管理します。
#
class ReminderMailerWorker
  include Sidekiq::Worker

  def perform(notification_id)
    puts 'hello'
    notification = Notification.find(notification_id)
    user = notification.user
    UserMailer.reminder_email(user).deliver_now
  end
end