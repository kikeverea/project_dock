FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    lastname { "Test" }
    sequence(:email) { |i| "user#{i}@nhs.com" }
    password { "12345678" }

    factory :admin do
      role { "admin" }
    end
  end
end
