FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    webhook_url { 'https://example.com' }
    password { User.digest('password') }
    email_notification { true }
    webhook_notification { true }
  end
end
