FactoryBot.define do
  factory :job_listing do
    name { Faker::Job.title }
  end
end
