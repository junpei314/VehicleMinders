# frozen_string_literal: true

# Notificationモデルの定義
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle

  after_create :schedule_reminder_mailer, if: -> { datetime.present? && user.email_notification }
  after_create :schedule_reminder_webhook, if: -> { datetime.present? && user.webhook_notification }
  before_destroy :cancel_jobs

  validate :notification_date_cannot_be_past
  validates :datetime, presence: true

  private

  def schedule_reminder_mailer
    jid = ReminderMailerWorker.perform_at((datetime - 9.hours), id)
    self.update(jid_email: jid)
  end

  def schedule_reminder_webhook
    jid = ReminderWebhookWorker.perform_at((datetime - 9.hours), id)
    self.update(jid_teams: jid)
  end

  def notification_date_cannot_be_past
    if datetime.present? && datetime < DateTime.now + 9.hours
      errors.add(:base, '過去の日付は選択できません')
    end
  end

  def cancel_jobs
    Sidekiq::ScheduledSet.new.find_job(jid_email)&.delete if jid_email
    Sidekiq::ScheduledSet.new.find_job(jid_teams)&.delete if jid_teams
  end
end
