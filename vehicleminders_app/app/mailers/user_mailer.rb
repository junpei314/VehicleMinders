# frozen_string_literal: true

# メール送信を管理するクラス
class UserMailer < ApplicationMailer
  def reminder_email(notification)
    @user = notification.user
    @vehicle = notification.vehicle
    @notification = notification
    mail(to: @user.email, subject: '【VehicleMinders】あなたの車両の車検期限が近づいています')
  end
end
