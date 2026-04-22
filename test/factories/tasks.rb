FactoryBot.define do
  factory :task do
    association :trip
    title { Faker::Name.name }
    status { "pending" }
    latest_status_at { Time.current - rand(1..15).days }
    association :latest_status_by, factory: :admin
    due_date { Time.current + rand(1..15).days }
    phase { Phase.all.sample }
    office { "front" }
  end
end
