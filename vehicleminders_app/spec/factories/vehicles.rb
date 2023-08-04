FactoryBot.define do
  factory :vehicle do
    maker { 'トヨタ' }
    model { 'プリウス' }
    production_year { 2019 }
    license_plate { '123-4567' }
    lease_expiry { '2023-07-17' }
    inspection_due { '2023-07-17' }
  end
end
