# frozen_string_literal: true

# Notificationモデルの定義
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle
  after_save :schedule_reminder_mailer, if: -> { datetime.present? && user.email_notification }
  after_save :schedule_reminder_webhook, if: -> { datetime.present? && user.webhook_notification }


  private

  def schedule_reminder_mailer
    ReminderMailerWorker.perform_at((datetime - 9.hours), id)
  end

  def schedule_reminder_webhook
    ReminderWebhookWorker.perform_at((datetime - 9.hours), id)
  end
end
