FactoryBot.define do
  factory :notification do
    datetime { Time.current + 1.day }
  end
end
