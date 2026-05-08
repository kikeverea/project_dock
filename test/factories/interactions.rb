FactoryBot.define do
  factory :task_comment do
    association :client
    association :user, factory: :admin
    text { Faker::Lorem.paragraph }
  end
end
