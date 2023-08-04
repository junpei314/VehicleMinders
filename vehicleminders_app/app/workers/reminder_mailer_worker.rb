# frozen_string_literal: true

# ReminderMailerWorker
#
# このワーカーは、メール送信を管理します。
#
class ReminderMailerWorker
  include Sidekiq::Worker

  def perform(notification_id)
    notification = Notification.find(notification_id)
    UserMailer.reminder_email(notification).deliver_now
  end
end
