# frozen_string_literal: true

# ApplicationMailer
class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@vehicleminders.com'
  layout 'mailer'
end
