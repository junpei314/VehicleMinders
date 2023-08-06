require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'callbacks' do
    context 'notificationレコードが保存されたとき' do

      let(:user) { create(:user) }
      let(:vehicle) { create(:vehicle, user: user) }
      let(:notification) { build(:notification, user: user, vehicle: vehicle) }

      it 'ReminderMailerWorkerジョブがキューに追加される' do
        expect {
          notification.save!
        }.to change(ReminderMailerWorker.jobs, :size).by(1)
      end

      it 'ReminderWebhookWorkerジョブがキューに追加される' do
        expect {
          notification.save!
        }.to change(ReminderWebhookWorker.jobs, :size).by(1)
      end

      it '追加されたReminderMailerWorkerジョブの実行時間がreminder_emailメソッドの引数で渡したnotificationレコードの日時とほぼ等しい' do
        job = ReminderMailerWorker.jobs.last
        expect(job['at']).to be_within(1.second).of((notification.datetime - 9.hours).to_f)
      end

      it '追加されたReminderWebhookWorkerジョブの実行時間がreminder_emailメソッドの引数で渡したnotificationレコードの日時とほぼ等しい' do
        job = ReminderWebhookWorker.jobs.last
        expect(job['at']).to be_within(1.second).of((notification.datetime - 9.hours).to_f)
      end
    end
  end
end
