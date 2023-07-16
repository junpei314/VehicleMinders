class UserMailer < ApplicationMailer
  def reminder_email(user)
    @user = user
    mail(from: 'custom-from@yourdomain.com', to: @user.email, subject: 'Your reminder')
  end
end
