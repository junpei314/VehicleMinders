require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'reminder_email' do
    let(:user) { create(:user) }
    let(:vehicle) { create(:vehicle, user: user) }
    let(:notification) { create(:notification, user: user, vehicle: vehicle) }
    let(:mail) { UserMailer.reminder_email(notification) }

    it 'reminder_emailメソッドの引数notificationレコードに紐づいた情報がヘッダーに含まれている' do
      expect(mail.subject).to eq('【VehicleMinders】あなたの車両の車検期限が近づいています')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@vehicleminders.com'])
    end

    it 'reminder_emailメソッドの引数notificationレコードに紐づいた情報がボディに含まれている' do
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(vehicle.maker)
      expect(mail.body.encoded).to match(vehicle.model)
      expect(mail.body.encoded).to match(vehicle.license_plate)
      expect(mail.body.encoded).to match(vehicle.inspection_due.to_s)
    end
  end
end
