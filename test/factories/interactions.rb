FactoryBot.define do
  factory :interaction do
    association :client
    association :user, factory: :admin
    text { Faker::Lorem.paragraph }
  end
end
