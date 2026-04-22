FactoryBot.define do
  factory :history_log do
    association :user, factory: :admin
    association :loggable, factory: :company
    description { Faker::Lorem.sentence }
    action { "created" }
  end
end
