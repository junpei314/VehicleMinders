# frozen_string_literal: true

# Notificationモデルの定義
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle

  after_save :schedule_reminder_mailer, if: -> { datetime.present? && user.email_notification }
  after_save :schedule_reminder_webhook, if: -> { datetime.present? && user.webhook_notification }

  validate :notification_date_cannot_be_past
  validates :datetime, presence: true

  private

  def schedule_reminder_mailer
    ReminderMailerWorker.perform_at((datetime - 9.hours), id)
  end

  def schedule_reminder_webhook
    ReminderWebhookWorker.perform_at((datetime - 9.hours), id)
  end

  def notification_date_cannot_be_past
    if datetime.present? && datetime < DateTime.now + 9.hours
      errors.add(:base, '過去の日付は選択できません')
    end
  end
end
