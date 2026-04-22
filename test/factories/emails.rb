FactoryBot.define do
  factory :email do
    email { Faker::Internet.email }
    primary { false }
  end
end
