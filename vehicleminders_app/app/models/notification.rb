class Notification < ApplicationRecord
  belongs_to :user
  after_save :schedule_reminder_mailer, if: -> { self.datetime.present? }

  private
  def schedule_reminder_mailer
    ReminderMailerWorker.perform_at((self.datetime - 9.hours), self.id)
  end
end
